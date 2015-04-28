! Subroutine VQUART
!
! This software is part of the GLOW model.  Use is governed by the Open Source
! Academic Research License Agreement contained in the file glowlicense.txt.
! For more information see the file glow.txt.
!
! TGCM routine obtained from C. Ridley, 9/88.
! Modified by Stan Solomon, 11/88, 5/91.
!
! Determines positive roots of equations of form:
! A(I,5)*X**4 + A(I,4)*X**3 + A(I,3)*X**2 + A(I,2)*X + A(I,1) = 0 
! It is specifically designed for real quartics with real roots,
! only one of which is positive.
! Coefficients of quartics supplied in array A(JMAX,5).
! Positive roots returned in ROOT(JMAX) for I from 1 to NJ.
! W1, W2, W3, W4, W5 are working arrays.
!
!
module vquartmod
    use machprec
    implicit none
    INCLUDE 'glow.h'
    private
    public :: vquart

    real(kind=dp) :: E =1.D-38, Z=0.
contains
    SUBROUTINE VQUART (A, ROOT, NJ)
    INCLUDE 'glow.h' ! f2py needs this here too
    Real(kind=dp),intent(out) :: ROOT(JMAX)
    Real(kind=dp),intent(in)  :: A(JMAX,5)
    Integer,intent(in)        :: NJ
      
    Integer I
    Real(kind=dp) :: W1(JMAX), W2(JMAX), W3(JMAX), W4(JMAX), W5(JMAX)

    DO I=1,NJ
        W1(I) = -(A(I,5)*A(I,1)-4.D0*A(I,4)*A(I,2)+3.D0*A(I,3)**2) / 12.D0
        W2(I) = ( A(I,5)*(A(I,3)*A(I,1)-A(I,2)**2)                          &
                  -A(I,4)*(A(I,4)*A(I,1)-A(I,2)*A(I,3))                     &
                  +A(I,3)*(A(I,4)*A(I,2)-A(I,3)**2)    ) / 4.D0
        W4(I)= -2.D0*DREAL(  ( (CMPLX(W2(I),Z)                             &
                         +SQRT(CMPLX(W2(I)**2+4.D0*W1(I)**3+E,Z)))/2.D0  &
                         +CMPLX(E,Z) )**(1.D0/3.D0)  )
        W1(I) = A(I,5)*W4(I) + A(I,4)**2 - A(I,5)*A(I,3) + E
        IF (W1(I) .LE. E) W1(I) = E
        W1(I) = SQRT(W1(I))
        W2(I) = (2.D0*W4(I)+A(I,3))**2 - A(I,5)*A(I,1)
        IF (W2(I) .LE. E) W2(I) = E
        W2(I) = SQRT(W2(I))
        W3(I) = 2.D0*A(I,4)*W4(I) + A(I,4)*A(I,3) - A(I,5)*A(I,2) + E
        W1(I) = SIGN(W1(I),W2(I)*W3(I))
        W3(I) = W1(I)-A(I,4)
        W5(I) = W3(I)**2 - A(I,5)*(A(I,3)+2.D0*W4(I)-W2(I))
        IF (W5(I) .LE. E) W5(I) = E
        ROOT(I) = (W3(I)+SQRT(W5(I))) / A(I,5)
    End Do


    END Subroutine VQUART
end module Vquartmod
