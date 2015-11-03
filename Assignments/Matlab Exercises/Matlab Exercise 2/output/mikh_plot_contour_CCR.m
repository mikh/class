function mikh_plot_contour_CCR( figure_number, CCR, x_scale, rbf_scale, plot_title, file_save )
    f = figure(figure_number);
    imagesc([min(x_scale), max(x_scale)],[min(rbf_scale), max(rbf_scale)], CCR);
    colorbar;
    xlabel('boxconstraint');
    ylabel('rbf-sigma');
    title(plot_title);
    saveas(f, file_save);
end

