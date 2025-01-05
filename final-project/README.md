# Traffic Flow Simulation

A sophisticated traffic flow simulation implementing various traffic models including the basic Nagel-Schreckenberg (NaSch) model, Velocity-Dependent Randomization (VDR) model, and Mixed VDR model for heterogeneous traffic conditions.

## Features

- Multiple traffic simulation models:
  - Basic NaSch Model
  - VDR (Velocity-Dependent Randomization) Model
  - Mixed VDR Model with car-truck interactions
- Interactive visualization of traffic flow
- Comprehensive traffic analysis tools
- Configurable simulation parameters
- Both single simulation and model comparison modes

├── main.py # Main entry point
├── traffic_simulation.py # Traffic model implementations
├── traffic_visualization.py # Visualization components
├── traffic_analysis.py # Analysis tools
├── requirements.txt # Package dependencies
└── README.md # This file

## Working the code

First, create a new virtual environment and install the dependencies:

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Then, run the simulation:

```bash
python main.py
```

After running the main file, you will be prompted to select a model type and mode. The available models are:

- `single`: Running each model individually
- `comparison`: Running each model back to back and comparing the results



