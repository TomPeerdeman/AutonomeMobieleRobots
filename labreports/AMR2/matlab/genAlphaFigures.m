for x=0:1:360
    f = figure();
    % Dit vereist de rho's inclusief de Inf waardes
    dist = undistort_dist_points(theta, rho, x, height);
    draw_undistorted_beam(dist, theta, axislimit);
    s1 = sprintf('Alpha %d', x);
    s2 = sprintf('alpha/alpha_%d.png', x);
    title(s1);
    saveas(f, s2, 'png');
    close(f);
end
