function l = labs(n)
%gives labels string of variable n
labels = {
      'Time (sec) '        'DISTGTN (NMi)'      'ALM (deg)     '    ...
      'ALAM (deg)    '     'ALTMSL (Ft)   '     'ETAPC (ft/sec^2)'  ...
      'AMBM3R (ft/sec^2)'  'ACMAX (ft/sec^2) '  'PHIC (deg) '       ...
      'PHI (deg)     '     'VMACH       '       'ALPHA (deg)       '...
      'TERAIN (ft)       ' 'XTKB (FT)         ' 'CG(2) (ft)     '   ...  
      'CG(3) (ft)      '   'ANCT(gee)   '       'VMAG (ft/sec)'     ... 
      'VRELM (ft/sec)   '  'DR (ft)          '  'THETA (deg)      ' ...
      'WGHT (lbs)      '   'W_9_1 (lbs)'        'WOFB (lbs)       ' ...
      'WOFBOFS (lb)   '    'CG(1) (ft)      '   'XCG (in)        '  };
l = labels(n);