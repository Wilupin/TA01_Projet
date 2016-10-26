!
! 1. Compiler et executer le code en local (pas à travers qsub)
! 2. Initiation à l'outil MPE/jumpshot:
!    - recompiler en remplacant mpif90 par mpefc (MPE Fortran compiler) et en
!      ajoutant l'option de compilation '-mpilog'
!    - exécuter à nouveau, vous devez constater qu'un fichier de 'log' a été
!      écrit, visualiser la trace temporelle associée avec l'outil graphique
!      jumpshot
! 3. Remplacer les variables scalaires dataSend / dataRecv par des tableaux
!    Compiler et vérifier le bon fonctionnement.
!    Visualiser les traces.
! 4. Remplacer l'appel bloquant à MPI_Send par un appel non-bloquant à 
!    MPI_ISend (compétence éxigible: savoir énoncer clairement la différence
!    entre les 2 modes fonctionnement).
!    Revisualiser les traces.
!



program helloworld_mpi2

  use mpi

  implicit none

  integer   :: nbTask, myRank, ierr, req
  integer, dimension(MPI_STATUS_SIZE)         :: status

  integer, parameter      :: N = 1048
  integer                 :: i     ! Variable pour le parcours du tableau
  integer, dimension(1:N) :: dataToSend1, dataRecv1, dataToSend2, dataRecv2

  call MPI_Init(ierr)

  call MPI_COMM_SIZE(MPI_COMM_WORLD, nbTask, ierr)
  call MPI_COMM_RANK(MPI_COMM_WORLD, myRank, ierr)

  write (*,*) 'I am task', myRank, 'out of',nbTask


  if (myRank == 0) then

     forall (i=1:N) dataToSend1(i) = 30

     write (*,*) "[Task ",myRank,"]: I'm sending data ",dataToSend1(1)," to rank 1"
     call MPI_Isend(dataToSend1, N, MPI_INTEGER, 1, 100, MPI_COMM_WORLD, req, ierr)
    
     call MPI_RECV(dataRecv2, N, MPI_INTEGER, 1, 100, MPI_COMM_WORLD, status, ierr) 
     write (*,*)  "[Task ",myRank,"] I received data ",dataRecv2(1)," from task 1"

  else if (myRank == 1) then

     forall (i=1:N) dataToSend2(i) = 40

     write (*,*) "[Task ",myRank,"]: I'm sending data ",dataToSend2(1)," to rank 0"
     call MPI_Isend(dataToSend2, N, MPI_INTEGER, 0, 100, MPI_COMM_WORLD, req, ierr)   
     call MPI_RECV(dataRecv1, N, MPI_INTEGER, 0, 100, MPI_COMM_WORLD, status, ierr)
     write (*,*) "[Task ",myRank,"] I received data ",dataRecv1(1)," from task 0"

   
  end if
  

  call MPI_Finalize(ierr)

end program helloworld_mpi2
