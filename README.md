# MPCTraIts

A **M**odel **P**redictive **C**ontrol for **Tra**cking with **I**mplicit Invariant Se**ts** implementation based on the paper by Irene Luque, Paula Chanfreut, Daniel Limon and Jose M. Maestre published in Automatica.

## Usage

- download CasADi and MPT3 and install them locally
- run `startup.m` in matlab and set the paths to CasADi and MPT3
- run one of the scripts from `tests/`

Note that results are saved in the `tests/` directory on the same level as the script. For example, if you run `tests/dtls/traits.m`, the result for the CSE1 model will be saved at `tests/dtls/CSE1_simulation.mat`. That can be further processed or visualised using the available plotting functions.

## Structure

```
MPCTraIts/
├── costs
├── examples
├── models
├── plots
├── README.md
├── startup.m
└── tests
```

The project follows a somewhat modular architecture. Most components (cost functions, models etc) are separated by category, such as discrete time linear systems (`dtls`). They are further subdivided by the algorithm, model or approach they are implementing, such as Implicit Invariant Sets (`IIS`).

### Costs

Cost functions closely resemble their mathematical equivalents. They are Matlab functions which take the plant and controller (and any other relevant variables) as parameters. They are used in Simulator classes, alongside CasADi, to calculate the optimal plant inputs and states.

### Examples

Examples consist of academic models (such as CSE) to be used in simulations for for plotting data.

### Models

#### Abstract

There are abstract classes for Plant, Controller and Simulator, with each one of them defining the expected parameters of discrete time linear systems and associated MPCs.

They use MPT3 Polygons, but that may be changed in the future to be able to use set representations from multiple toolboxes.

#### Implicit Invariant Sets (IIS)

`IIS_*` classes directly inherit the abstract classes mentioned above. They add variables and methods specific to MPC for Tracking with Implicit Invariant Sets, such as augmented reference points or an extended prediction horizon.

### Plots

Specific plots are defined to make data visualisation easier. As of now, they are defined as raw Matlab functions and there are no classes or shared structure among them.

### Tests

In order to visualize output data from MPC simulations, tests may be conducted, based (for example) on data from `examples/`.

To facilitate modularity and ease of usage, data loading, class instantiation and data plotting have been separated.

#### Models

Getter (`get_*`) functions are defined to instantiate plant, controller and simulator objects.

Based on the functions mentioned above, a more generic script (such as `traits.m`) may be written which runs an entire pipeline of loading data, running a simulation and plotting its results.