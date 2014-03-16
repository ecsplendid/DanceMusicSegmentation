function [] = save_result( name, average_loss, heuristic_loss, average_shifts )

    fn = sprintf('../results/%s', name);
    save(fn);
    
    fid = fopen('../results/results.txt', 'at');
    fprintf(fid, sprintf('%s -> mean=%.2f, heuristic=%.2f shiftavg=%.2f\n', ...
        name, mean(average_loss), mean(heuristic_loss), mean(average_shifts) ));
    fclose('all');
end