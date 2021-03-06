module RtmHistFlds

!-----------------------------------------------------------------------
! !DESCRIPTION:
! Module containing initialization of RTM history fields and files
! This is the module that the user must modify in order to add new
! history fields or modify defaults associated with existing history
! fields.
!
! !USES:
  use shr_kind_mod   , only: r8 => shr_kind_r8
  use RunoffMod      , only : rtmCTL
  use RtmHistFile    , only : RtmHistAddfld, RtmHistPrintflds
  use RtmVar         , only : wrmflag, inundflag
#ifdef INCLUDE_WRM
  use WRM_type_mod  , only : ctlSubwWRM, WRMUnit, StorWater
#endif
  use rof_cpl_indices, only : nt_rtm, rtm_tracers  

  implicit none
!
! !PUBLIC MEMBER FUNCTIONS:
  public :: RtmHistFldsInit 
  public :: RtmHistFldsSet
!
!------------------------------------------------------------------------

contains

!-----------------------------------------------------------------------

  subroutine RtmHistFldsInit()

    !-------------------------------------------------------
    ! DESCRIPTION:
    ! Build master field list of all possible fields in a history file.
    ! Each field has associated with it a ``long\_name'' netcdf attribute that
    ! describes what the field is, and a ``units'' attribute. A subroutine is
    ! called to add each field to the masterlist.
    !
    ! ARGUMENTS:
    implicit none
    !-------------------------------------------------------

    call RtmHistAddfld (fname='MASK', units='none',  &
         avgflag='A', long_name='MOSART mask 1=land 2=ocean 3=outlet ', &
         ptr_rof=rtmCTL%rmask, default='active')

    call RtmHistAddfld (fname='GINDEX', units='none',  &
         avgflag='A', long_name='MOSART global index ', &
         ptr_rof=rtmCTL%rgindex, default='active')

    call RtmHistAddfld (fname='DSIG', units='none',  &
         avgflag='A', long_name='MOSART downstream index ', &
         ptr_rof=rtmCTL%rdsig, default='active')

    call RtmHistAddfld (fname='OUTLETG', units='none',  &
         avgflag='A', long_name='MOSART outlet index ', &
         ptr_rof=rtmCTL%routletg, default='active')

    call RtmHistAddfld (fname='RIVER_DISCHARGE_OVER_LAND'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART river basin flow: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%runofflnd_nt1, default='active')

    call RtmHistAddfld (fname='RIVER_DISCHARGE_OVER_LAND'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART river basin flow: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%runofflnd_nt2, default='active')

    call RtmHistAddfld (fname='RIVER_DISCHARGE_TO_OCEAN'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART river discharge into ocean: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%runoffocn_nt1, default='active')

    call RtmHistAddfld (fname='RIVER_DISCHARGE_TO_OCEAN'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART river discharge into ocean: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%runoffocn_nt2, default='active')

    call RtmHistAddfld (fname='TOTAL_DISCHARGE_TO_OCEAN'//'_'//trim(rtm_tracers(1)), units='m3/s', &
         avgflag='A', long_name='MOSART total discharge into ocean: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%runofftot_nt1, default='active')

    call RtmHistAddfld (fname='TOTAL_DISCHARGE_TO_OCEAN'//'_'//trim(rtm_tracers(2)), units='m3/s', &
         avgflag='A', long_name='MOSART total discharge into ocean: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%runofftot_nt2, default='active')

    call RtmHistAddfld (fname='DIRECT_DISCHARGE_TO_OCEAN'//'_'//trim(rtm_tracers(1)), units='m3/s', &
         avgflag='A', long_name='MOSART direct discharge into ocean: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%runoffdir_nt1, default='active')

    call RtmHistAddfld (fname='DIRECT_DISCHARGE_TO_OCEAN'//'_'//trim(rtm_tracers(2)), units='m3/s', &
         avgflag='A', long_name='MOSART direct discharge into ocean: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%runoffdir_nt2, default='active')

    call RtmHistAddfld (fname='STORAGE'//'_'//trim(rtm_tracers(1)), units='m3',  &
         avgflag='A', long_name='MOSART storage: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%volr_nt1, default='active')

    call RtmHistAddfld (fname='STORAGE'//'_'//trim(rtm_tracers(2)), units='m3',  &
         avgflag='A', long_name='MOSART storage: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%volr_nt2, default='active')

    call RtmHistAddfld (fname='DVOLRDT_LND'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART land change in storage: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%dvolrdtlnd_nt1, default='inactive')

    call RtmHistAddfld (fname='DVOLRDT_LND'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART land change in storage: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%dvolrdtlnd_nt2, default='inactive')

    call RtmHistAddfld (fname='DVOLRDT_OCN'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART ocean change of storage: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%dvolrdtocn_nt1, default='inactive')

    call RtmHistAddfld (fname='DVOLRDT_OCN'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART ocean change of storage: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%dvolrdtocn_nt2, default='inactive')

    call RtmHistAddfld (fname='QSUR'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='ALM irrigation demand: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%qsur_nt1, default='active')
       !MOSART input surface runoff was modified to ALM irrigation demand by Yuna 1/29/2018

    call RtmHistAddfld (fname='QSUR'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='ALM irrigation demand: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%qsur_nt2, default='active')
       !MOSART input surface runoff was modified to ALM irrigation demand by Yuna 1/29/2018

    call RtmHistAddfld (fname='QSUB'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART input subsurface runoff: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%qsub_nt1, default='active')

    call RtmHistAddfld (fname='QSUB'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART input subsurface runoff: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%qsub_nt2, default='active')

    call RtmHistAddfld (fname='QGWL'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART input GWL runoff: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%qgwl_nt1, default='active')

    call RtmHistAddfld (fname='QGWL'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART input GWL runoff: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%qgwl_nt2, default='active')

    call RtmHistAddfld (fname='QDTO'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART input direct to ocean runoff: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%qdto_nt1, default='active')

    call RtmHistAddfld (fname='QDTO'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART input direct to ocean runoff: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%qdto_nt2, default='active')

    call RtmHistAddfld (fname='QDEM'//'_'//trim(rtm_tracers(1)), units='m3/s',  &
         avgflag='A', long_name='MOSART input surface runoff: '//trim(rtm_tracers(1)), &
         ptr_rof=rtmCTL%qdem_nt1, default='active')

    call RtmHistAddfld (fname='QDEM'//'_'//trim(rtm_tracers(2)), units='m3/s',  &
         avgflag='A', long_name='MOSART input surface runoff: '//trim(rtm_tracers(2)), &
         ptr_rof=rtmCTL%qdem_nt2, default='active')

#ifdef INCLUDE_WRM
    if (wrmflag) then

      call RtmHistAddfld (fname='WRM_SUPPLY', units='m3/s',  &
         avgflag='A', long_name='WRM supply provided ', &
         ptr_rof=StorWater%Supply, default='active')
      !call RtmHistAddfld (fname='WRM_SUPPLY_FRACTION', units='none',  &
      !   avgflag='A', long_name='WRM supply fraction relative to demand ', &
      !   ptr_rof=StorWater%SupplyFrac, default='active')                                                                                                                               

      call RtmHistAddfld (fname='WRM_DEMAND', units='m3/s',  &
         avgflag='A', long_name='WRM new demand after supply: same as deficit ', &
         ptr_rof=StorWater%demand, default='active')

      call RtmHistAddfld (fname='WRM_DEMAND0', units='m3/s',  &
         avgflag='A', long_name='WRM demand requested ', &
         ptr_rof=StorWater%demand0, default='active')

      call RtmHistAddfld (fname='WRM_DEFICIT', units='m3/s',  &
         avgflag='A', long_name='WRM deficit ', &
         ptr_rof=StorWater%deficit, default='active')

      call RtmHistAddfld (fname='WRM_STORAGE', units='m3',  &
         avgflag='A', long_name='WRM storage ', &
         ptr_rof=StorWater%storageG, default='active')
    endif
#endif

#ifdef INCLUDE_INUND
    if (inundflag) then
      call RtmHistAddfld (fname='FLOODPLAIN_VOLUME', units='m3',  &
         avgflag='A', long_name='MOSART floodplain water volume', &
         ptr_rof=rtmCTL%inundwf, default='active')
      call RtmHistAddfld (fname='FLOODPLAIN_DEPTH', units='m',  &
         avgflag='A', long_name='MOSART floodplain water depth', &
         ptr_rof=rtmCTL%inundhf, default='active')
        !!!!!!!!!!! added by Tian Dec 2017 
      call RtmHistAddfld (fname='FLOODPLAIN_FRACTION', units='none',  &
         avgflag='A', long_name='MOSART floodplain water area fraction', &
         ptr_rof=rtmCTL%inundff, default='active')
		!!!!!!!!!!!!!!!!!!!!!!!!
    endif
#endif

    ! Print masterlist of history fields

    call RtmHistPrintflds()

  end subroutine RtmHistFldsInit

!-----------------------------------------------------------------------

  subroutine RtmHistFldsSet()

    !-----------------------------------------------------------------------
    ! !DESCRIPTION:
    ! Set mosart history fields as 1d poitner arrays
    !
    implicit none
    integer :: idam, ig
    !-----------------------------------------------------------------------

    ! Currently only have two tracers

    rtmCTL%rmask(:)          = rtmCTL%mask(:)
    rtmCTL%rgindex(:)        = rtmCTL%gindex(:)
    rtmCTL%rdsig(:)          = rtmCTL%dsig(:)
    rtmCTL%routletg(:)       = rtmCTL%outletg(:)

    rtmCTL%runofflnd_nt1(:)  = rtmCTL%runofflnd(:,1)
    rtmCTL%runofflnd_nt2(:)  = rtmCTL%runofflnd(:,2)

    rtmCTL%runoffocn_nt1(:)  = rtmCTL%runoffocn(:,1)
    rtmCTL%runoffocn_nt2(:)  = rtmCTL%runoffocn(:,2)

    rtmCTL%runofftot_nt1(:)  = rtmCTL%runofftot(:,1)
    rtmCTL%runofftot_nt2(:)  = rtmCTL%runofftot(:,2)

    rtmCTL%runoffdir_nt1(:)  = rtmCTL%direct(:,1)
    rtmCTL%runoffdir_nt2(:)  = rtmCTL%direct(:,2)

    rtmCTL%dvolrdtlnd_nt1(:) = rtmCTL%dvolrdtlnd(:,1)
    rtmCTL%dvolrdtlnd_nt2(:) = rtmCTL%dvolrdtlnd(:,2)

    rtmCTL%dvolrdtocn_nt1(:) = rtmCTL%dvolrdtocn(:,1)
    rtmCTL%dvolrdtocn_nt2(:) = rtmCTL%dvolrdtocn(:,2)

    rtmCTL%volr_nt1(:)       = rtmCTL%volr(:,1)
    rtmCTL%volr_nt2(:)       = rtmCTL%volr(:,2)

    rtmCTL%qsub_nt1(:)       = rtmCTL%qsub(:,1)
    rtmCTL%qsub_nt2(:)       = rtmCTL%qsub(:,2)

    rtmCTL%qsur_nt1(:)       = rtmCTL%qsur(:,1)
    rtmCTL%qsur_nt2(:)       = rtmCTL%qsur(:,2)

    rtmCTL%qgwl_nt1(:)       = rtmCTL%qgwl(:,1)
    rtmCTL%qgwl_nt2(:)       = rtmCTL%qgwl(:,2)

    rtmCTL%qdto_nt1(:)       = rtmCTL%qdto(:,1)
    rtmCTL%qdto_nt2(:)       = rtmCTL%qdto(:,2)

    rtmCTL%qdem_nt1(:)       = rtmCTL%qdem(:,1)
    rtmCTL%qdem_nt2(:)       = rtmCTL%qdem(:,2)

#ifdef INCLUDE_WRM
    if (wrmflag) then
       StorWater%storageG = 0._r8
       do idam = 1, ctlSubwWRM%localNumDam
          ig = WRMUnit%icell(idam)
          StorWater%storageG(ig) = StorWater%storage(idam)
       enddo
    endif
#endif

  end subroutine RtmHistFldsSet


end module RtmHistFlds
