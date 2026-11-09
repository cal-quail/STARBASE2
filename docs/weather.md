# Hyperlocal weather simulation

A real weather model on the rack, forecasting conditions around the school. Side project, on its own VM on node 2.

## How it works

NOAA gridded model data → **WRF** simulates → the campus weather station and radar check the result. The station is ground truth, not an input; one point can't drive a 3D simulation.

| Piece | Detail |
| --- | --- |
| WRF 4.7.1 (ARW) + WPS 4.7.0 | Built from source; 3 nested domains (12 km → 4 km → 1.33 km) centered on the school |
| Input | NOAA GFS 0.25° (HRRR later), hourly western-US subset |
| Plots | Rain totals, radar and temperature loops, station meteogram |
| Validation | Campus station observations (only kept about 120 days, so fetch them promptly) |

## On the website

- **Forecast viewer** (`/weather`): plots and validation for each run.
- **Live radar** (`/radar`): NWS radar loops and alerts for the school's location, using public NOAA map services.
- **Radar nowcast:** every 5 minutes the VM extrapolates current radar 6–60 minutes ahead (optical flow) and pushes the frames to the web server over a key restricted to one folder. It also tracks its own skill against "persistence".

## Results so far

The Sep 29 2026 rain event (30 h, about 3 h of compute on 28 MPI ranks) ran cleanly. The model put the heavy rain southeast of the valley and gave the school 0.03" against 0.44" measured: valley convection was under-forecast. Temperature error averaged 3.2 °F, and wind ran about 7 mph too strong.

## Build gotchas

- Ubuntu's OpenMPI links libpsm2, which needs **AVX2**. These Xeons don't have it, so every MPI program dies with "illegal instruction". Build OpenMPI from source without psm2/ofi/ucx.
- gfortran 15 needs `-fallow-argument-mismatch -fallow-invalid-boz`.
- jasper 4 removed `jpc_decode`; patch ungrib's JPEG2000 decoder.
- Never `./clean -a` (it wipes the patched configure file), and `./compile` overwrites `run/namelist.input`.

## Next

- [ ] Automate forecast runs on a schedule
- [ ] Switch to HRRR
- [ ] Sub-km nest with urban canopy physics
- [ ] Share with the science department
