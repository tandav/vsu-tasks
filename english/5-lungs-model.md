# Computer Lungs Model `[summary]`

This article is describing a computer model of sound propagation in the human lungs.

The model uses the Visible Human male data set for a realistic representation of the human thorax. 

Sound propagation behavior is analyzed under various conditions using arti􏰀cial sound sources.

## Introduction
In the introduction section author tell us about given problem, it's complexity and a little bit of history. 

He says that Sound propagation requires the solution of the inhomogeneous wave equation

The speci􏰀c objectives of this article are to:

1. develop a parallel supercomputer model for sound propagation in the human thorax;
2. incorporate realistic spatial heterogeneity into the model using computed tomography (CT) scan
images from the Visible Human male data set;
3. study the e􏰁ffects of spatial heterogeneity, the size of human thorax, con􏰀nement of sound waves
within the chest wall, and frequency of the sound source on recorded sounds.

## Sound propagation model
starts with following assumptions:
- medium behaves like a 􏰂uid
- medium is stationary
- A completely re􏰂ective boundary conditions

Author examines the main equation of this model
    - partial differential equation (PDE) inhomogeneous wave equation

Then - solution of this equation:
Finite di􏰁erence approximations based on explicit time stepping and second order central di􏰁fferencing in space (using a 7-point stencil) were developed for solving equation

Initial and boundary conditions

how to use Computed tomography (CT) dataset from Human Visible Project Computed tomography (CT) dataset from Human Visible Project

## Parallel implementation
explanation of parallel computations o nsupercomputer

## Results and discussion
Several simulations were conducted using the sound propagation model to study the e􏰁ffects on the results of 

1. changing driving frequency
2. changing sampling location
3. altering the size of the thorax
4. altering spatial heterogeneity

## Conclusions
Author tells about limitations and possible improvements of model

# Vocab
thorax - грудная клетка

