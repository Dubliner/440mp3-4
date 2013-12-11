%% convert from txt file to a n-by-1 vector
function labellist = label_vector(filename, vectorcount)
    fid = fopen(filename);
    labellist = zeros(vectorcount, 1);
    
    rowcount = 1;
    
    currlabel = fgetl(fid);
    while ischar(currlabel)        
        
        labellist(rowcount) = str2num(currlabel);
        
        rowcount = rowcount+1;
        
        
        currlabel = fgetl(fid);
    end
    
    fclose(fid);

end