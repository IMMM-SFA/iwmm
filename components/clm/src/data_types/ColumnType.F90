module ColumnType

  !-----------------------------------------------------------------------
  ! !DESCRIPTION:
  !DW  Converted from ColumnType
  !DW  Change the old function into PhysicalPropertiesType
  ! Column data type allocation and initialization
  ! -------------------------------------------------------- 
  ! column types can have values of
  ! -------------------------------------------------------- 
  !   1  => (istsoil)          soil (vegetated or bare soil)
  !   2  => (istcrop)          crop (only for crop configuration)
  !   3  => (istice)           land ice
  !   4  => (istice_mec)       land ice (multiple elevation classes)   
  !   5  => (istdlak)          deep lake
  !   6  => (istwet)           wetland
  !   71 => (icol_roof)        urban roof
  !   72 => (icol_sunwall)     urban sunwall
  !   73 => (icol_shadewall)   urban shadewall
  !   74 => (icol_road_imperv) urban impervious road
  !   75 => (icol_road_perv)   urban pervious road
  !
  use shr_kind_mod   , only : r8 => shr_kind_r8
  use shr_infnan_mod , only : nan => shr_infnan_nan, assignment(=)
  use clm_varpar     , only : nlevsno, nlevgrnd, nlevlak
  use clm_varcon     , only : spval, ispval
  use column_varcon  , only : is_hydrologically_active
  !
  ! !PUBLIC TYPES:
  implicit none
  save
  private
  !
  type, public :: column_physical_properties_type
     ! g/l/c/p hierarchy, local g/l/c/p cells only
     integer , pointer :: landunit             (:)   ! index into landunit level quantities
     real(r8), pointer :: wtlunit              (:)   ! weight (relative to landunit)
     integer , pointer :: gridcell             (:)   ! index into gridcell level quantities
     real(r8), pointer :: wtgcell              (:)   ! weight (relative to gridcell)
     integer , pointer :: pfti                 (:)   ! beginning pft index for each column
     integer , pointer :: pftf                 (:)   ! ending pft index for each column
     integer , pointer :: npfts                (:)   ! number of patches for each column

     ! topological mapping functionality
     integer , pointer :: itype                (:)   ! column type
     logical , pointer :: active               (:)   ! true=>do computations on this column 

     ! topography
     real(r8), pointer :: glc_topo             (:)   ! surface elevation (m)
     real(r8), pointer :: micro_sigma          (:)   ! microtopography pdf sigma (m)
     real(r8), pointer :: n_melt               (:)   ! SCA shape parameter
     real(r8), pointer :: topo_slope           (:)   ! gridcell topographic slope
     real(r8), pointer :: topo_std             (:)   ! gridcell elevation standard deviation
     real(r8), pointer :: hslp                 (:)   ! hillslope average slope (unitless)
     real(r8), pointer :: hslp_p10             (:,:) ! hillslope slope percentiles (unitless)
     real(r8), pointer :: znsoil               (:)   ! soil depth (m)
     integer, pointer  :: nlevbed              (:)   ! number of layers to bedrock
     real(r8), pointer :: zibed                (:)   ! bedrock depth in model (interface level at nlevbed)

     ! vertical levels
     integer , pointer :: snl                  (:)   ! number of snow layers
     real(r8), pointer :: dz                   (:,:) ! layer thickness (m)  (-nlevsno+1:nlevgrnd) 
     real(r8), pointer :: z                    (:,:) ! layer depth (m) (-nlevsno+1:nlevgrnd) 
     real(r8), pointer :: zi                   (:,:) ! interface level below a "z" level (m) (-nlevsno+0:nlevgrnd) 
     real(r8), pointer :: zii                  (:)   ! convective boundary height [m]
     real(r8), pointer :: dz_lake              (:,:) ! lake layer thickness (m)  (1:nlevlak)
     real(r8), pointer :: z_lake               (:,:) ! layer depth for lake (m)
     real(r8), pointer :: lakedepth            (:)   ! variable lake depth (m)                             

     ! other column characteristics
     logical , pointer :: hydrologically_active(:)   ! true if this column is a hydrologically active type

   contains

     procedure, public :: Init => col_pp_init
     procedure, public :: Clean => col_pp_clean

  end type column_physical_properties_type

  type(column_physical_properties_type), public, target :: col_pp !column data structure (soil/snow/canopy columns)
  !------------------------------------------------------------------------

contains
  
  !------------------------------------------------------------------------
  subroutine col_pp_init(this, begc, endc)
    !
    ! !ARGUMENTS:
    class(column_physical_properties_type)  :: this
    integer, intent(in) :: begc,endc
    !------------------------------------------------------------------------

    ! The following is set in initGridCellsMod
    allocate(this%gridcell    (begc:endc))                     ; this%gridcell    (:)   = ispval
    allocate(this%wtgcell     (begc:endc))                     ; this%wtgcell     (:)   = nan
    allocate(this%landunit    (begc:endc))                     ; this%landunit    (:)   = ispval
    allocate(this%wtlunit     (begc:endc))                     ; this%wtlunit     (:)   = nan
    allocate(this%pfti        (begc:endc))                     ; this%pfti        (:)   = ispval
    allocate(this%pftf        (begc:endc))                     ; this%pftf        (:)   = ispval
    allocate(this%npfts       (begc:endc))                     ; this%npfts       (:)   = ispval
    allocate(this%itype       (begc:endc))                     ; this%itype       (:)   = ispval
    allocate(this%active      (begc:endc))                     ; this%active      (:)   = .false.

    ! The following is set in initVerticalMod
    allocate(this%snl         (begc:endc))                     ; this%snl         (:)   = ispval  !* cannot be averaged up
    allocate(this%dz          (begc:endc,-nlevsno+1:nlevgrnd)) ; this%dz          (:,:) = nan
    allocate(this%z           (begc:endc,-nlevsno+1:nlevgrnd)) ; this%z           (:,:) = nan
    allocate(this%zi          (begc:endc,-nlevsno+0:nlevgrnd)) ; this%zi          (:,:) = nan
    allocate(this%zii         (begc:endc))                     ; this%zii         (:)   = nan
    allocate(this%lakedepth   (begc:endc))                     ; this%lakedepth   (:)   = spval  
    allocate(this%dz_lake     (begc:endc,nlevlak))             ; this%dz_lake     (:,:) = nan
    allocate(this%z_lake      (begc:endc,nlevlak))             ; this%z_lake      (:,:) = nan

    allocate(this%glc_topo    (begc:endc))                     ; this%glc_topo    (:)   = nan
    allocate(this%micro_sigma (begc:endc))                     ; this%micro_sigma (:)   = nan
    allocate(this%n_melt      (begc:endc))                     ; this%n_melt      (:)   = nan 
    allocate(this%topo_slope  (begc:endc))                     ; this%topo_slope  (:)   = nan
    allocate(this%topo_std    (begc:endc))                     ; this%topo_std    (:)   = nan
    allocate(this%hslp        (begc:endc))                     ; this%hslp        (:)   = nan
    allocate(this%hslp_p10    (begc:endc,10))                  ; this%hslp_p10    (:,:) = nan
    allocate(this%znsoil      (begc:endc))                     ; this%znsoil      (:)   = nan
    allocate(this%nlevbed     (begc:endc))                     ; this%nlevbed     (:)   = ispval
    allocate(this%zibed       (begc:endc))                     ; this%zibed       (:)   = nan

    allocate(this%hydrologically_active(begc:endc))            ; this%hydrologically_active(:) = .false.

  end subroutine col_pp_init

  !------------------------------------------------------------------------
  subroutine col_pp_clean(this)
    !
    ! !ARGUMENTS:
    class(column_physical_properties_type) :: this
    !------------------------------------------------------------------------

    deallocate(this%gridcell   )
    deallocate(this%wtgcell    )
    deallocate(this%landunit   )
    deallocate(this%wtlunit    )
    deallocate(this%pfti       )
    deallocate(this%pftf       )
    deallocate(this%npfts      )
    deallocate(this%itype      )
    deallocate(this%active     )
    deallocate(this%snl        )
    deallocate(this%dz         )
    deallocate(this%z          )
    deallocate(this%zi         )
    deallocate(this%zii        )
    deallocate(this%lakedepth  )
    deallocate(this%dz_lake    )
    deallocate(this%z_lake     )
    deallocate(this%glc_topo   )
    deallocate(this%micro_sigma)
    deallocate(this%n_melt     )
    deallocate(this%topo_slope )
    deallocate(this%topo_std   )
    deallocate(this%hslp       )
    deallocate(this%hslp_p10   )
    deallocate(this%znsoil     )
    deallocate(this%nlevbed    )
    deallocate(this%zibed      )
    deallocate(this%hydrologically_active)

  end subroutine col_pp_clean


end module ColumnType
