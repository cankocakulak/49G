import matplotlib.pyplot as plt
import numpy as np

class TrafficSimulation:
    def __init__(self, road_length=100, num_cars=30, max_velocity=5, p_slow=0.3, 
                 boundary_type='closed', alpha=0.3, beta=0.3):
        self.road_length = road_length
        self.road = [0] * road_length
        self.velocities = {}
        self.max_velocity = max_velocity
        self.p_slow = p_slow
        self.boundary_type = boundary_type
        self.alpha = alpha  # Probability of car entering (open boundary)
        self.beta = beta    # Probability of car leaving (open boundary)
        
        if boundary_type == 'closed':
            # Initialize with fixed number of cars for closed boundary
            positions = np.random.choice(road_length, num_cars, replace=False)
            for i, pos in enumerate(positions, 1):
                self.road[pos] = i
                self.velocities[i] = np.random.randint(0, max_velocity + 1)
        self.next_car_id = len(self.velocities) + 1
    
    def get_distance_to_next_car(self, position):
        distance = 1
        pos = (position + 1) % self.road_length if self.boundary_type == 'closed' else position + 1
        
        while distance <= self.road_length:
            if pos >= self.road_length:
                return distance if self.boundary_type == 'open' else 1
            if self.road[pos] != 0:
                return distance
            distance += 1
            pos += 1
        return distance

    def update(self):
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
            
            # NaSch model steps
            v = min(v + 1, self.max_velocity)
            v = min(v, d - 1)
            if np.random.random() < self.p_slow:
                v = max(v - 1, 0)
            
            new_velocities[car_id] = v
            
            # Handle movement and exit for open boundary
            new_pos = pos + v
            if self.boundary_type == 'open':
                if new_pos >= self.road_length:
                    if np.random.random() < self.beta:
                        del new_velocities[car_id]  # Car exits
                    else:
                        new_road[pos] = car_id  # Car stays
                else:
                    new_road[new_pos] = car_id
            else:  # Closed boundary
                new_pos = new_pos % self.road_length
                new_road[new_pos] = car_id
        
        self.road = new_road
        self.velocities = new_velocities
    
    def get_state(self):
        return self.road, self.velocities
    
    def get_density_profile(self, window_size=10):
        """Calculate density profile along the road"""
        profile = []
        for i in range(0, self.road_length, window_size):
            section = self.road[i:i+window_size]
            density = sum(1 for x in section if x != 0) / len(section)
            profile.append(density)
        return profile

