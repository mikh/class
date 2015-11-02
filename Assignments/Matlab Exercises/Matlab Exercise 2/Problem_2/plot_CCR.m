function plot_CCR( figure_number, CCR, x_scale, plot_title, file_save )
    f = figure(figure_number);
    semilogx(x_scale, CCR);
    title(plot_title);
    xlabel('boxconstraint');
    ylabel('CCR rate (%)');
    saveas(f, file_save);
end

