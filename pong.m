function pong
W = 100; H = 60;
paddleW = 2; paddleH = 8;
ballSize = 1;
speed = 0.007;
paddleSpeed = 0.05;
maxVY = 2.0;
fig = figure('Name','MATLAB Pong','Color','k','MenuBar','none', ...
    'NumberTitle','off','Position',[300 300 800 480], ...
    'KeyPressFcn',@keyPress,'KeyReleaseFcn',@keyRelease, ...
    'CloseRequestFcn',@(s,~) delete(s));
ax = axes(fig,'XLim',[0 W],'YLim',[0 H],'Color','k','NextPlot','add');
axis(ax,'off');
p1y = (H-paddleH)/2;  p2y = p1y;
p1 = rectangle(ax,'Position',[3 p1y paddleW paddleH], ...
    'FaceColor','w','EdgeColor','w');
p2 = rectangle(ax,'Position',[W-3-paddleW p2y paddleW paddleH], ...
    'FaceColor','w','EdgeColor','w');
bx = W/2; by = H/2;
bvx = speed; bvy = 0.5*speed;
ball = rectangle(ax,'Position',[bx by ballSize ballSize], ...
    'Curvature',[1 1],'FaceColor','w','EdgeColor','w');
s1 = 0; s2 = 0;
scoreTxt = text(ax,W/2,H-5,'0 : 0','Color','w','FontSize',18, ...
    'HorizontalAlignment','center');
keys = struct('up1',false,'dn1',false,'up2',false,'dn2',false);
    function keyPress(~,ev)
        switch ev.Key
            case 'w',        keys.up1 = true;
            case 's',        keys.dn1 = true;
            case 'uparrow',  keys.up2 = true;
            case 'downarrow',keys.dn2 = true;
            case 'escape',   delete(fig);
        end
    end
    function keyRelease(~,ev)
        switch ev.Key
            case 'w',        keys.up1 = false;
            case 's',        keys.dn1 = false;
            case 'uparrow',  keys.up2 = false;
            case 'downarrow',keys.dn2 = false;
        end
    end
    while isvalid(fig)
        %move paddles
        if keys.up1, p1y = min(H-paddleH, p1y + paddleSpeed); end
        if keys.dn1, p1y = max(0,         p1y - paddleSpeed); end
        if keys.up2, p2y = min(H-paddleH, p2y + paddleSpeed); end
        if keys.dn2, p2y = max(0,         p2y - paddleSpeed); end
        set(p1,'Position',[3 p1y paddleW paddleH]);
        set(p2,'Position',[W-3-paddleW p2y paddleW paddleH]);

        %move ball
        bx = bx + bvx;  by = by + bvy;

        %walls
        if by <= 0,            by = 0;            bvy = -bvy; end
        if by+ballSize >= H,   by = H-ballSize;   bvy = -bvy; end

        %left
        if bvx < 0 && bx <= 3+paddleW && by+ballSize >= p1y && by <= p1y+paddleH
            bx = 3+paddleW;
            bvx = -bvx;
            bvy = bvy + 0.15*(by - (p1y+paddleH/2));   % spin
        end
        %right
        if bvx > 0 && bx+ballSize >= W-3-paddleW && ...
                by+ballSize >= p2y && by <= p2y+paddleH
            bx = W-3-paddleW-ballSize;
            bvx = -bvx;
            bvy = bvy + 0.15*(by - (p2y+paddleH/2));
        end
        bvy = max(-maxVY, min(maxVY, bvy));
        %scoring
        if bx < 0
            s2 = s2 + 1;  bx = W/2; by = H/2;
            bvx = speed;  bvy = speed*0.7*(2*(rand<0.5)-1);
        elseif bx > W
            s1 = s1 + 1;  bx = W/2; by = H/2;
            bvx = -speed; bvy = speed*0.7*(2*(rand<0.5)-1);
        end
        set(ball,'Position',[bx by ballSize ballSize]);
        set(scoreTxt,'String',sprintf('%d : %d',s1,s2));
        drawnow limitrate;
    end
end