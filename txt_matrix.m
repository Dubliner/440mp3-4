function numberlist = txt_matrix(filename, matrixcount)
    fid = fopen(filename);
    numberlist = zeros(28, 28, matrixcount);
    matrixind = 1;
    rowcount = 1;
    
    currline = fgetl(fid);
    while ischar(currline)
       
       for i=1:28
           if currline(i)=='+'||currline(i)=='#'
               numberlist(rowcount, i, matrixind) = 1;
           end
       end
       
       
       if mod(rowcount, 28) == 0
           rowcount = 0;
           matrixind = matrixind+1;
       end
       rowcount = rowcount+1;
       currline = fgetl(fid); 
    end
    
    fclose(fid);
    

end