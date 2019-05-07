#/bin/bash
if [ $# -eq 0 ];then
  echo "Usage prepare_plumed.sh [lmp | gulp] [nn] <plumed_file>"
  exit
fi

nn=$2
if [ $# -ne 2 ];then
  pl_file=$3
else
  pl_file=plumed.mtd.inp
fi

dir=Walker

if [ $1 == "lmp" ]; then
  for ((i=0;i<$nn;i++));do

    if [ ! -d ${dir}_${i} ];then
      mkdir ${dir}_${i}
    fi

    cd ${dir}_${i}
   
    if [ ! -f lammps.inp ];then
      ln -s ../lammps.inp ./
    fi
  
    if [ ! -f coord.lmp ];then
      ln -s ../coord.lmp ./
    fi

    sed "s/XXXX/${i}/" ../${pl_file} > tmp
    sed "s/XXX/${i}/" tmp > ${pl_file}
  
    sed "s/XXXX/${i}/" ../plumed.equi.inp > tmp
    sed "s/XXX/${i}/" tmp > plumed.equi.inp
  
    rm tmp
    cd ../
  done
elif [ $1 == "gulp" ]; then
  for ((i=0;i<$nn;i++));do

    if [ ! -d ${dir}_${i} ];then
      mkdir ${dir}_${i}
    fi

    cd ${dir}_${i}
   
    if [ ! -f gulp.gin ];then
      ln -s ../gulp.gin ./
    fi
  
    if [ ! -f coord.gin ];then
      gpta3.x --i ../coord.pdb --top --o coord.gin
    fi
  
    sed "s/XXXX/${i}/" ../${pl_file} > tmp
    sed "s/XXX/${i}/" tmp > ${pl_file}
  
    rm tmp
    cd ../
  done
  
else
  echo "Unknown program" $1
fi

if [ ! -d HILLS_DIR ]; then
  mkdir HILLS_DIR
fi
for ((i=0;i<$nn;i++));do
  touch HILLS_DIR/HILLS.${i}
done
