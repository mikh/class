function [ values,l, TT, ETT ] = load_txt_file(txt_file_name, read_string, loading_string, TT, ETT)
    fprintf(loading_string);
    t1 = clock;
    
    values = textread(txt_file_name, read_string);
    l = length(values);
    t2 = clock;
    elapsed_time = etime(t2,t1);
    TT = TT + elapsed_time;
    ETT = ETT + elapsed_time;
    fprintf('Done. (%.2fs)\n', elapsed_time);
end

