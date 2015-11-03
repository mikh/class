function [ value1, value2, value3,l, TT, ETT ] = mikh_load_txt_file_into_3_ints(txt_file_name, loading_string, TT, ETT)
    fprintf(loading_string);
    t1 = clock;
    
    [value1, value2, value3] = textread(txt_file_name, '%d %d %d');
    l = length(value1);
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

