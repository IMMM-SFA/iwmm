*Forked from [E3SM-Project/E3SM](https://github.com/E3SM-Project/E3SM/tree/v1.1.1) at tag `v1.1.1` and merged with [hydrotian/E3SM](https://github.com/hydrotian/E3SM/tree/apcraig/mosart/add-inundation) at the `apcraig/mosart/add-inundation` branch. Please refer to the linked repositories for the original READMEs and documentation.*

Integrated Water Management Model (IWMM)
========================================

This fork of E3SM focuses on modeling runnoff with integrated water management, representing the effect of humans (reservoirs and demand).


Getting Started
---------------

This guide assumes, for now, that you will be running your simulations on the PIC.

To ensure that your environment is setup correctly, you'll need to run the following commands once connected to the PIC. It is advisable to include them in your `~/.bashrc` file so that you won't need to run them everytime you log in.

```bash
ulimit -s unlimited
module load git
module load gcc/5.2.0
module load R/3.4.3
module load python/2.7.3
```

To obtain the code, navigate to your preferred working directory and run:
```bash
git clone https://github.com/IMMM-SFA/iwmm.git
```

To create a new case (i.e. setup a new simulation), substituting <YOUR_CASE_NAME> with something appropriate:
```bash
cd iwmm/cime/scripts
./create_newcase --case <YOUR_CASE_NAME> --res NLDAS_NLDAS --compset mosart_runoff_driven --project IM3
cd <YOUR_CASE_NAME>
./case.setup
```

**Before proceeding**, you will want to specify parameters specific to your simulation. For instance:
To change the water resource management (WRM) parameters, or to disable it altogether, edit the file `user_nl_mosart`.
To change the start date and duration:
```bash
./xmlchange RUN_STARTDATE=1986-12-15
./xmlchange STOP_OPTION=nyears
./xmlchange STOP_N=32
```
This would create a simulation starting on December 15 1986 and running for 32 years. `STOP_OPTION` accepts most reasonable time units, prefixed with `n`, such as nminutes, ndays, nmonths, nyears, nsteps.
To align the demand files in a particular way (being careful to respect the periodicity of leap years):
```bash
./xmlchange DLND_CPLHIST_YR_ALIGN=1986
./xmlchange DLND_CPLHIST_YR_START=1986
./xmlchange DLND_CPLHIST_YR_END=2019
```
This would align the demand years with the simulation years. If the years are misaligned relative to leap years, an error will occur.

To build the case:
```bash
./case.build
```

To submit the simulation to the PIC:
```bash
./case.submit
```

To monitor the status of the case, you can watch the `CaseStatus` file:
```bash
tail -f CaseStatus
```

When the simulation ends, either naturally or due to an error, `CaseStatus` will indicate the location of the results or the error log.


Development Workflow
--------------------

See [Code Tracking Workflows](https://immm-sfa.atlassian.net/wiki/spaces/IP/pages/642809857/Code+Tracking+Workflows) for recommendations on code management with git. Essentially: create a new branch off `development` when writing new code. Create a Pull Request back into `development` when satisified with your work. Tag code related to specific experiments or publications with a useful descriptor.

