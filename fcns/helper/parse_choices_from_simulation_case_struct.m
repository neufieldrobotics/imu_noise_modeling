function choices = parse_choices_from_simulation_case_struct(simulation_case)
    f = fieldnames(simulation_case);
    a = [];
    for k = 1:length(f)
        f_ = simulation_case.(f{k});
        if  f_ == 1
            a = [a,f(k)];
        end
    end
    choices = a;
end
