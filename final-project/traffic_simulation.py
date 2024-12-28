from vehicle_types import VehicleType, VEHICLE_PROPERTIES
import numpy as np

class BaseTrafficSimulation:
    """Base class for traffic simulation implementing basic NaSch model"""
    
    def __init__(self, road_length, num_cars, max_velocity, p_slow,
                 boundary_type, alpha, beta):
        self.road_length = road_length
        self.road = [0] * road_length
        self.velocities = {}
        self.max_velocity = max_velocity
        self.p_slow = p_slow
        self.boundary_type = boundary_type
        self.alpha = alpha
        self.beta = beta
        
        # Initialize cars
        if boundary_type == 'closed':
            positions = np.random.choice(road_length, num_cars, replace=False)
            for i, pos in enumerate(positions, 1):
                self.road[pos] = i
                self.velocities[i] = np.random.randint(0, max_velocity + 1)
        self.next_car_id = len(self.velocities) + 1
        
        # Track statistics
        self.flow_history = []
        self.density_history = []

    def get_distance_to_next_car(self, position):
        """Calculate distance to next car ahead"""
        if position >= self.road_length - 1:
            return 1 if self.boundary_type == 'closed' else self.road_length
            
        distance = 1
        pos = position + 1
        
        while pos < self.road_length:
            if self.road[pos] != 0:
                return distance
            distance += 1
            pos += 1
            
        if self.boundary_type == 'closed':
            pos = 0
            while pos < position:
                if self.road[pos] != 0:
                    return distance
                distance += 1
                pos += 1
                
        return distance

    def get_slowdown_probability(self, car_id):
        """Get slowdown probability for a car (overridden in VDR model)"""
        return self.p_slow

    def get_density_profile(self, window_size):
        """Calculate density profile along the road"""
        profile = []
        for i in range(0, self.road_length, window_size):
            section = self.road[i:min(i+window_size, self.road_length)]
            density = sum(1 for x in section if x != 0) / len(section)
            profile.append(density)
        return profile

    def update(self):
        """Update simulation state"""
        new_road = [0] * self.road_length
        new_velocities = {}  # Start with empty dict to avoid stale entries
        
        # Handle entrance for open boundary
        if self.boundary_type == 'open' and self.road[0] == 0:
            if np.random.random() < self.alpha:
                new_car_id = max(self.velocities.keys()) + 1 if self.velocities else 1
                new_road[0] = new_car_id
                new_velocities[new_car_id] = 0
        
        # Update existing cars
        car_positions = [(pos, car_id) for pos, car_id in enumerate(self.road) if car_id != 0]
        
        for pos, car_id in car_positions:
            if car_id in self.velocities:  # Only process cars we have velocity for
                v = self.velocities[car_id]
                d = self.get_distance_to_next_car(pos)
                
                # Step 1: Acceleration
                v = min(v + 1, self.max_velocity)
                
                # Step 2: Deceleration
                v = min(v, d - 1)
                
                # Step 3: Randomization
                if np.random.random() < self.get_slowdown_probability(car_id):
                    v = max(0, v - 1)
                
                # Step 4: Movement
                new_pos = pos + v
                
                if self.boundary_type == 'open':
                    if new_pos >= self.road_length - 1:
                        if np.random.random() < self.beta:
                            continue  # Car exits the system
                        else:
                            new_road[pos] = car_id
                            new_velocities[car_id] = v
                    else:
                        new_road[new_pos] = car_id
                        new_velocities[car_id] = v
                else:  # periodic boundary
                    new_pos = new_pos % self.road_length
                    new_road[new_pos] = car_id
                    new_velocities[car_id] = v
        
        self.road = new_road
        self.velocities = new_velocities
        
        # Update statistics
        self.update_statistics()

    def update_statistics(self):
        """Update flow and density history"""
        self.flow_history.append(self.get_current_flow())
        self.density_history.append(self.get_current_density())

    def get_current_density(self):
        """Calculate current traffic density"""
        return sum(1 for x in self.road if x != 0) / self.road_length

    def get_current_flow(self):
        """Calculate current traffic flow"""
        if not self.velocities:
            return 0
        return sum(self.velocities.values()) / self.road_length

    def get_state(self):
        """Return current state of the simulation"""
        return self.road, self.velocities


class VDRTrafficSimulation(BaseTrafficSimulation):
    """VDR extension of the traffic simulation"""
    
    def __init__(self, road_length, num_cars, max_velocity, p_slow, p0_slow,
                 boundary_type, alpha, beta):
        super().__init__(road_length, num_cars, max_velocity, p_slow,
                        boundary_type, alpha, beta)
        self.p0_slow = p0_slow  # Additional slowdown probability for stopped cars

    def get_slowdown_probability(self, car_id):
        """Override to implement VDR behavior"""
        return self.p0_slow if self.velocities[car_id] == 0 else self.p_slow


class MixedVDRTrafficSimulation(VDRTrafficSimulation):
    def __init__(self, road_length: int, num_cars: int, max_velocity: int,
                 p_slow: float, p0_slow: float, boundary_type: str = 'periodic',
                 alpha: float = 0.3, beta: float = 0.3,
                 truck_ratio: float = 0.15):
        # Initialize parent VDR model first
        super().__init__(road_length, num_cars, max_velocity, p_slow, p0_slow, 
                        boundary_type, alpha, beta)
        
        self.truck_ratio = truck_ratio
        self.vehicle_types = {}
        self.num_vehicles = int(num_cars * 0.7)
        
        # Inherit VDR characteristics and add vehicle-specific modifications
        self.vehicle_properties = {
            VehicleType.CAR: {
                'max_velocity': max_velocity,
                'min_velocity': 0,
                'acceleration': 1.0,
                'p_slow': p_slow,
                'p0_slow': p0_slow,
                'recovery_rate': 0.7
            },
            VehicleType.TRUCK: {
                'max_velocity': max(2, max_velocity - 1),
                'min_velocity': 0,
                'acceleration': 0.9,
                'p_slow': p_slow * 1.15,
                'p0_slow': p0_slow * 1.1,
                'recovery_rate': 0.65
            }
        }
        
        self._initialize_mixed_vehicles()

    def _initialize_mixed_vehicles(self):
        """Initialize vehicles with mixed types"""
        self.road = [0] * self.road_length
        self.velocities = {}
        self.vehicle_types = {}
        
        num_trucks = int(self.num_vehicles * self.truck_ratio)
        num_cars = self.num_vehicles - num_trucks
        
        # Create evenly spaced positions within road length
        min_spacing = max(3, self.road_length // (self.num_vehicles * 2))
        available_positions = list(range(0, self.road_length - min_spacing, min_spacing))
        
        if len(available_positions) < self.num_vehicles:
            self.num_vehicles = len(available_positions)
            num_trucks = int(self.num_vehicles * self.truck_ratio)
            num_cars = self.num_vehicles - num_trucks
        
        np.random.shuffle(available_positions)
        
        # Initialize trucks
        for i in range(num_trucks):
            vehicle_id = i + 1
            pos = available_positions[i]
            self.road[pos] = vehicle_id
            self.velocities[vehicle_id] = 1  # Start trucks with minimal velocity
            self.vehicle_types[vehicle_id] = VehicleType.TRUCK
        
        # Initialize cars
        for i in range(num_trucks, self.num_vehicles):
            vehicle_id = i + 1
            pos = available_positions[i]
            self.road[pos] = vehicle_id
            self.velocities[vehicle_id] = 1  # Start cars with minimal velocity
            self.vehicle_types[vehicle_id] = VehicleType.CAR

    def update(self):
        """Update simulation state using VDR rules with vehicle-specific modifications"""
        new_road = [0] * self.road_length
        new_velocities = {}
        new_vehicle_types = {}
        
        # Handle entrance (inherit from VDR)
        if self.boundary_type == 'open' and self.road[0] == 0:
            if np.random.random() < self.alpha:
                new_car_id = max(self.velocities.keys()) + 1 if self.velocities else 1
                new_road[0] = new_car_id
                vehicle_type = np.random.choice(
                    [VehicleType.CAR, VehicleType.TRUCK],
                    p=[1 - self.truck_ratio, self.truck_ratio]
                )
                new_velocities[new_car_id] = 0  # Start from stop (VDR rule)
                new_vehicle_types[new_car_id] = vehicle_type
        
        # Update existing vehicles
        car_positions = [(pos, car_id) for pos, car_id in enumerate(self.road) if car_id != 0]
        
        for pos, car_id in car_positions:
            if car_id in self.velocities and car_id in self.vehicle_types:
                vehicle_type = self.vehicle_types[car_id]
                v = self.velocities[car_id]
                props = self.vehicle_properties[vehicle_type]
                
                # VDR rules with vehicle-specific modifications
                d = self.get_distance_to_next_car(pos)
                
                # Step 1: Acceleration (VDR)
                if v == 0:
                    # Apply VDR rules for standing vehicles
                    if np.random.random() < props['recovery_rate']:
                        v = 1
                else:
                    # Normal acceleration with vehicle-specific rates
                    v = min(v + props['acceleration'], props['max_velocity'])
                
                v = int(v)
                
                # Step 2: Distance consideration (VDR)
                v = min(v, d - 1)
                
                # Step 3: Randomization (VDR with vehicle specifics)
                if v == 0:
                    # Stopped vehicles (VDR p0_slow)
                    if np.random.random() < props['p0_slow']:
                        v = 0
                else:
                    # Moving vehicles (VDR p_slow)
                    if np.random.random() < props['p_slow']:
                        v = max(0, v - 1)
                
                # Step 4: Movement
                new_pos = pos + v
                
                if self.boundary_type == 'open':
                    if new_pos >= self.road_length - 1:
                        if np.random.random() < self.beta:
                            continue
                        else:
                            new_road[pos] = car_id
                            new_velocities[car_id] = v
                            new_vehicle_types[car_id] = vehicle_type
                    else:
                        new_road[new_pos] = car_id
                        new_velocities[car_id] = v
                        new_vehicle_types[car_id] = vehicle_type
                else:
                    new_pos = new_pos % self.road_length
                    new_road[new_pos] = car_id
                    new_velocities[car_id] = v
                    new_vehicle_types[car_id] = vehicle_type
        
        self.road = new_road
        self.velocities = new_velocities
        self.vehicle_types = new_vehicle_types