function adjustLegendSize(lgd, hobj, widthFactor, heightFactor, tokenLineWidth,repos)
% ADJUSTLEGENDSIZE  Expand a legend box (anchored at its current Location)
%                  and thicken its line-tokens.
%
%   adjustLegendSize(lgd, wF, hF, tLW)
% repos = 1 is Right, 0 is Left

  hl = findobj(hobj,'type','line');
  set(hl, 'LineWidth', tokenLineWidth, 'MarkerSize', 100);
  % 2) Resize but keep the top-right corner fixed
  lgd.Units = 'normalized';
  pos       = lgd.Position;      % [x0 y0 w0 h0]
  oldX      = pos(1);
  oldY      = pos(2);
  oldW      = pos(3);
  oldH      = pos(4);

  

  % Compute new size
  newW = oldW * widthFactor;
  newH = oldH * heightFactor;

  % Recompute bottom-left so top-right stays put
  if repos == 1
      % Compute the fixed top-right corner
      topRightX = oldX + oldW;
      topRightY = oldY + oldH;  
      newX = topRightX - newW*.65;
      newY = topRightY - newH*.75;
  else
      topLeftX = oldX - oldW;
      topLeftY = oldY + oldH; 
      newX = topLeftX + newW;%*.65 ;
      newY = topLeftY - newH*.75 ;
  end

  % Apply new position
  lgd.Position = [ newX, newY, newW, newH ];

end

% -----------------------------------------------------------------------
function hobj = hobjFromLegend(lgd)
% Extract the graphic children from the legend
  try
    hobj = lgd.EntryContainer.Children;
  catch
    % older releases
    [~, hobj, ~, ~] = legend(lgd);
  end
end
