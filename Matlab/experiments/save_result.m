
fn = sprintf('../results/%s', name);
save(fn);

clear C;
clear SC;
clear audio_low;

st = mean(thresholds);

fid = fopen('../results/results.txt', 'at');

if( length( st ) > 1)

    fprintf(fid, sprintf('%s -> mean=%.2f, heuristic=%.2f shiftavg=%.2f 60=%.2f 30=%.2f 20=%.2f 10=%.2f 5=%.2f 1=%.2f', ...
        name, mean(average_loss), mean(heuristic_loss), mean(average_shifts),...
        st(1), st(2), st(3), st(4), st(5), st(6)));

else
    
    fprintf(fid, sprintf('%s -> mean=%.2f, heuristic=%.2f shiftavg=%.2f\n', ...
        name, mean(average_loss), mean(heuristic_loss), mean(average_shifts)));
end

fclose('all');
