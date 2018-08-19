#!/bin/bash
root_dir=`pwd`
mkdir ../target
cd ../target
tar_dir=`pwd`
cd "$root_dir"

getdir(){
cur_dir=`pwd`
cd "$1"
for file in *
do
    if test -f "$file"
    then
        echo "-发现文件 "$file >> $tar_dir/flist.log
        filename=$(basename "$file")
        dirname=`pwd | awk -F "/" '{print $NF}'`
        ext="${filename##*.}"
        fname="${filename%.*}"
        if test $ext = "mp3"
        then
            lame --decode "$file" "$tar_dir/$dirname/$fname.wav"
            echo "----转换 "$dirname/$file" 到 "$tar_dir/$dirname/$fname.wav >>$tar_dir/flist.log
        else
            cp "$file" "$tar_dir/$dirname"
            echo "---复制 "$dirname/$file" 到 "$tar_dir/$dirname/$file >> $tar_dir/flist.log
        fi    
    else
        if test -d "$file"
        then
            echo "发现目录 "$file >> $tar_dir/flist.log
            mkdir "$tar_dir/$file" 
            getdir "$file"
            echo "--创建目录 "$tar_dir/$file >> $tar_dir/flist.log
        else
            echo "!发现未知 "$file 啥也不是 >> $tar_dir/flist.log
        fi
    fi
done
cd ..
}

getdir $1