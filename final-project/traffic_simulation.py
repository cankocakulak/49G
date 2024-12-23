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
        new_velocities = self.velocities.copy()
        
        # Handle entrance for open boundary
        if self.boundary_type == 'open' and self.road[0] == 0:
            if np.random.random() < self.alpha:
                new_car_id = self.next_car_id
                self.next_car_id += 1
                new_road[0] = new_car_id
                new_velocities[new_car_id] = 0
        
        # Update existing cars
        car_positions = [(pos, car_id) for pos, car_id in enumerate(self.road) if car_id != 0]
        
        for pos, car_id in car_positions:
            v = self.velocities[car_id]
            d = self.get_distance_to_next_car(pos)
            
            # Step 1: Acceleration
            v = min(v + 1, self.max_velocity)
            
            # Step 2: Deceleration
            v = min(v, d - 1)
            
            # Step 3: Randomization
            if np.random.random() < self.get_slowdown_probability(car_id):
                v = max(v - 1, 0)
            
            new_velocities[car_id] = v
            
            # Step 4: Movement
            new_pos = pos + v
            if self.boundary_type == 'open':
                if new_pos >= self.road_length - 1:
                    if np.random.random() < self.beta:
                        del new_velocities[car_id]
                    else:
                        new_road[pos] = car_id
                else:
                    new_road[new_pos] = car_id
            else:
                new_pos = new_pos % self.road_length
                new_road[new_pos] = car_id
        
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

