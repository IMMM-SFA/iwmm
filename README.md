*Forked from [E3SM-Project/E3SM](https://github.com/E3SM-Project/E3SM/tree/v1.1.1) at tag `v1.1.1` and merged with [hydrotian/E3SM](https://github.com/hydrotian/E3SM/tree/apcraig/mosart/add-inundation) at the `apcraig/mosart/add-inundation` branch. Please refer to the linked repositories for the original READMEs and documentation.*

Integrated Water Management Model (IWMM)
========================================

This fork of E3SM focuses on modeling runnoff with integrated water management, representing the effect of humans (reservoirs and demand).

More detailed documentation and customizations to follow.


Workflow
--------

- The `master` branch will track major releases from the parent `E3SM` repository, currently at `v1.1.1`.
- The `development` branch will house the main codebase, which integrates `E3SM` with the `hydrotian/apcraig/mosart/add-inundation` fork.
- Development work should occur in branches prefixed with `feature/`.
  - For instance: `feature/rainbows` could contain work that considers the effect of rainbows on water management.
  - Should this work become relevant to IWMM as a whole, a Pull Request (PR) should be submitted to the `development` branch. This will allow team members and peers to review, discuss, and test the code before merging it.
  - From time to time, the `development` branch will receive new code that may be relevant to ongoing work in `feature/` branches. If desired, these updates can be merged into `feature/` branches.
- When an experiment is finalized, the code should be tagged with an `experiment/` prefix.
  - For instance: `experiment/rainbows` could represent a published milestone in the rainbows research.
  - Tags can be created from any fully commited branch with a command like: `git tag experiment/rainbows`. Send the tag to the repository with a command like: `git push origin experiment/rainbows`.
  - It may be more relevant to qualify the tag with the publication name and/or authors, so that it is more easily associated with the correct work.


