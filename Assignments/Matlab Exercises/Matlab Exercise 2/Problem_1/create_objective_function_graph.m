function create_objective_function_graph( t_max, f_theta )
    f = figure(1);
    plot(1:t_max, f_theta);
    title('Objective function vs. iterations');
    xlabel('Iterations');
    ylabel('Objective Function value');
    saveas(f, 'objective_function_vs_iterations.png');
end

