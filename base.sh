#!/bin/bash  

cd ./configs/
rm -f kustomization.yaml
kustomize init
kustomize edit add resource "./promotables"

echo "kustomization file generation stated..."

for dir in */ ; do
        echo "processing dir $dir"
        if [[ $dir == commons/* ]]; then
                updateStratey=create
                configMapNameSuffix="common-config"
                baseDir=""
        elif [[ $dir == promotables/* ]]; then
                updateStratey=merge
                configMapNameSuffix="promotable-config"
                baseDir="../specifics"
        elif [[ $dir == specifics/* ]]; then
                updateStratey=merge
                configMapNameSuffix="specific-config"
                baseDir="../commons"
        else
            echo "ERROR! No Rules Matched for $dir"
            exit 1
        fi

        
        cd $dir
        rm -f kustomization.yaml
        kustomize init
        kustomize edit add resource $baseDir
        for file in */** ; do
                echo "processing file $file"
                
                fileNameWithOutPath=`basename $file`
                fileNameExtn=${fileNameWithOutPath##*.}
                fileNameWithOutPathAndExtn=`basename $file .$fileNameExtn`
                if [[ $file == envs/* ]]; then
                        kustomize edit add configmap $fileNameWithOutPathAndExtn --behavior=$updateStratey --from-env-file=$file --disableNameSuffixHash         
                elif [[ $file == values/* ]]; then
                        kustomize edit add configmap $fileNameWithOutPathAndExtn-$configMapNameSuffix --behavior=create --from-file=$file --disableNameSuffixHash
                fi
        done
        cd ..
done
echo "kustomization file generation finished..."


