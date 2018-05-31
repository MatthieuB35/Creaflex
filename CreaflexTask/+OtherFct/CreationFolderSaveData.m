function Created=CreationFolderSaveData(Path,Save,NameFolder)

if Save==1 && ~(exist([Path '/' NameFolder],'dir')==7)
    mkdir([Path '/' NameFolder])
end

Created=[Path '/' NameFolder];

end