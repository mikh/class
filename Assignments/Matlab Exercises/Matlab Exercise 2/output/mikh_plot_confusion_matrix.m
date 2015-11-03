function mikh_plot_confusion_matrix( figure_number, con_mat, x_scale, plot_title, file_save )
    f = figure(figure_number);

    N = length(con_mat);
    precision = zeros(N,1);
    recall = zeros(N,1);
    f_score = zeros(N,1);

    for i = 1:N
    	con_matrix = con_mat{i};

    	precision(i) = con_matrix(1,1)/(con_matrix(1,1) + con_matrix(1,2));
    	recall(i) = con_matrix(1,1)/(con_matrix(1,1) + con_matrix(2,1));
    	f_score(i) = 2 * (precision(i)*recall(i))/(precision(i) + recall(i));
	end

	hold on
    semilogx(x_scale, precision);
   	semilogx(x_scale, recall);
   	semilogx(x_scale, f_score);
    hold off
    title(plot_title);
    xlabel('boxconstraint');
    ylabel('CCR rate (%)');
    legend('Precision', 'Recall', 'F-Score');
    saveas(f, file_save);

    [max_p_v, max_p_i] = max(precision);
    fprintf('The best C value based on precision is 2^%d\nIt''s Confusion matrix is:\n', max_p_i+(-5)-1);
    disp(con_mat{max_p_i});

    [max_r_v, max_r_i] = max(recall);
    fprintf('The best C value based on recall is 2^%d\nIt''s Confusion matrix is:\n', max_r_i+(-5)-1);
    disp(con_mat{max_r_i});
end

