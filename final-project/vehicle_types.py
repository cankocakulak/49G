from enum import Enum
from dataclasses import dataclass

class VehicleType(Enum):
    """Enum for different vehicle types"""
    CAR = 'car'
    TRUCK = 'truck'

@dataclass
class VehicleProperties:
    """Properties for each vehicle type"""
    max_velocity: int
    acceleration: float
    length: int
    color: str

# Define properties for each vehicle type
VEHICLE_PROPERTIES = {
    VehicleType.CAR: VehicleProperties(
        max_velocity=5,
        acceleration=1.0,
        length=1,
        color='blue'
    ),
    VehicleType.TRUCK: VehicleProperties(
        max_velocity=3,
        acceleration=0.5,
        length=2,
        color='red'
    )
}