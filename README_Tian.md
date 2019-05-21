## Changes made (APR 3 2019)
- Add two-way coupling scheme. Most of the changes can be found [here](http://simhydro.com/notebook/programming/e3sm/2018/10/01/E3SM-code-modify.html).
- A water relocation scheme is introduced to fix the water allocation issue caused by the grid mismatch between ELM and MOSART.
 
## Changes made (APR 2 2019)
- Merge previous changes to E3SM repo (add-inundation branch), on top of Zeli's commit (5848eae1c).

## Changes made (May 2 2018)
- Add real elevation profile reading for inundation. 
  * note the MOSART input file needs to add the elevation variable accordingly if using real elevation profile.
- Add inundation fraction variable as an output.
- Fix the bug that using grid-cell level surface water supply at pft level in two way coupling.

## Changes made (APR 19 2018)
- Add `DemandVariableName` into MOSART user defined namelist **user_nl_mosart** to specify which variable to read for external water demand.
- In **clm_varctl.F90** add `TwoWayCouplingFlag` to control one way or two way coupling between ELM and MOSART, default is one way.

## Changes made (APR 11 2018)

- Add external demand import option for RMGLB05 compset.
  - to use it, active the `externaldemandflag` and `demandpath` in the **user_nl_mosart** file.
  - note the default variable to be read in the demand nc file is `nonirri_demand`.
- Bugs fixed.
  - in **rof_comp_mct.F90** added unit conversion for supply passing from MOSART to ELM.
  - unifying the unit (mm/s) for demand0 and supply in the MOSART output files.
- Add `real_irrigation` variable in the ELM output to present actual irrigation applied.
- Add `TwoWayCouplingFlag` in **clm_varctl.F90** to make one way and two way coupling flexiable.

