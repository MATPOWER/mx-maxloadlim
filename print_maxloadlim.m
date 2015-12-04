function print_maxloadlim(mpc,results)
define_constants;

% Print some global information about the parameters and results of the
% maximum loadability limit problem
fprintf('\n');
fprintf('=======================================\n');
fprintf('      Maximum loadability problem\n');
fprintf('=======================================\n');
fprintf('The stability margin is %.2f MW\n',results.stab_marg*results.baseMVA);
fprintf('The type of bifurcation is %s (%s).\n',...
    results.bif.full_name,results.bif.short_name);
if strcmp(results.bif.short_name,'LIB')
    fprintf('Generator responsible for LIB: Gen %d connected at bus %d\n',...
        results.bif.gen_sll,results.gen(results.bif.gen_sll,GEN_BUS));
end
fprintf('------------------------------------\n');
fprintf('   Bus nb    Direction     Load at MLL \n');
fprintf('   ------    ---------     -----------\n');
for i = 1:size(results.bus,1)
    fprintf('   %4d      %5d         %8.2f\n',...
        results.bus(i,BUS_I),results.dir_mll(i),results.bus(i,PD));
end

% Print some global information about the generators and their limits
% First we extract the original voltage set points of the generators
gen_v_set = mpc.gen(:,VG);

fprintf('\n');
fprintf('=============================================================\n');
fprintf('Reactive power production and voltages at the generators\n');
fprintf('=============================================================\n');
fprintf('   Bus nb      Qgen       Qlim        Vm      Vref\n');
fprintf('  --------    -------    ------      -----    -----\n');
for i = 1:size(results.gen,1)
    fprintf('   %4d       %7.2f    %7.2f    %5.4f   %5.4f',...
        results.gen(i,GEN_BUS),results.gen(i,QG),results.gen(i,QMAX),...
        results.bus(results.gen(i,GEN_BUS),VM),gen_v_set(i));
    if results.bus(results.gen(i,GEN_BUS),BUS_TYPE) == REF
        fprintf('    REF');
    end
    if strcmp(results.bif.short_name,'LIB') && results.bif.gen_sll == i
        fprintf('    LIB');
    end
    fprintf('\n');
end

end