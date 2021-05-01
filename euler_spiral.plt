reset
set angle rad

#=================== Parameters ====================
N = int(5e3)         # If you integrate using Simpson's rule, N is even.
num = 360            # Output (num+1) images
numPNG = 0
lineWidth = 2.
pointSize = 1.5e-2
trange = 15.         #[-trange:trange]

limitCenterX = sqrt(pi/2)/2
limitCenterY = sqrt(pi/2)/2

#=================== Functions ====================
# Integrands of Fresnel integrals
c(t) = cos(t**2)
s(t) = sin(t**2)

# Fresnel integral using composite trapezoidal rule
# fresnelC(t) = (h = t/N, h/2*(c(0)+2*(sum[i=1:N-1]c(h*i))+c(t)))
# fresnelS(t) = (h = t/N, h/2*(s(0)+2*(sum[i=1:N-1]s(h*i))+s(t)))

# Fresnel integral using composite Simpson's rule
fresnelC(t) = (h = t/N, h/3*(sum[i=1:N/2]c((2*i-2)*h)+4*c((2*i-1)*h)+c(2*i*h)))
fresnelS(t) = (h = t/N, h/3*(sum[i=1:N/2]s((2*i-2)*h)+4*s((2*i-1)*h)+s(2*i*h)))

# The osculating circle
centerX(t) = fresnelC(t) - sin(t**2)/(2*t)
centerY(t) = fresnelS(t) + cos(t**2)/(2*t)
radius(t) = 1./(2*abs(t))

# Distance between (x1,y1), (x2,y2)
dist(x1, y1, x2, y2) = sqrt((x2-x1)**2 + (y2-y1)**2)

#=================== Setting ====================
set term pngcairo truecolor enhanced dashed size 720, 720 font 'Times, 18'
folderName = 'png'
system sprintf('mkdir %s', folderName)
set size ratio -1
set nokey
set grid
set samples 5e3
range = 1.0
set xr[-range:range]
set yr[-range:range]
set xl '{/:Italic x}'
set yl '{/:Italic y}'
set parametric

#=================== Plot and Output ====================
do for [i=0:num:1]{
  set output sprintf("%s/img_%04d.png", folderName, numPNG)
  numPNG = numPNG + 1
  ti = trange/num * i
  ti_next = trange/num * (i+1)
  set trange [-ti:ti]
  set title sprintf("%.2f ≦ {/:Italic t} ≦ %.2f", -ti, ti)

  # Since you calculate Fresnel integrals using Numerical integral,
  # the following codes exmaine calculation accuracy.
  if(i > 0){
    nowDistance = dist(fresnelC(ti), fresnelS(ti), limitCenterX, limitCenterY)
    nextDistance = dist(fresnelC(ti_next), fresnelS(ti_next), limitCenterX, limitCenterY)

    if(nowDistance < nextDistance){
      print 'Error! Poor accuracy!' ; exit # Recommend you to reset N
    }
  }

  # Draw two osculating circles
  if(i != 0){
    # Shorten lines to draw within graph area.
    if(centerY(ti) > range){
      tan2 = atan2(fresnelS(ti)-centerY(ti), fresnelC(ti)-centerX(ti)) # Angle of line
      cutY = centerY(ti) - range
      cutX = cutY/tan(tan2)
    } else {
      cutY = 0
      cutX = 0
    }

    # Radius of curvature
    set arrow 1 nohead from centerX(ti)+cutX,  centerY(ti)-cutY  to fresnelC(ti),  fresnelS(ti)  lw lineWidth lc rgb 'red' # x>0, y>0
    set arrow 2 nohead from centerX(-ti)-cutX, centerY(-ti)+cutY to fresnelC(-ti), fresnelS(-ti) lw lineWidth lc rgb 'red' # x<0, y<0
    # Osculating circle
    set object 1 circle at centerX(ti),  centerY(ti)  size radius(ti)  fc rgb 'red' fill transparent solid 0.2 noborder
    set object 2 circle at centerX(-ti), centerY(-ti) size radius(-ti) fc rgb 'red' fill transparent solid 0.2 noborder
    # Center of curvature
    set object 3 circle at centerX(ti),  centerY(ti)  size pointSize   fc rgb 'red' fill solid
    set object 4 circle at centerX(-ti), centerY(-ti) size pointSize   fc rgb 'red' fill solid
    # Point of tangency
    set object 5 circle at fresnelC(ti),  fresnelS(ti)  size pointSize fc rgb 'royalblue' fill solid front
    set object 6 circle at fresnelC(-ti), fresnelS(-ti) size pointSize fc rgb 'royalblue' fill solid front
  }

  # Draw two limit points
  set object 7 circle at  limitCenterX,  limitCenterY size pointSize fc rgb 'black' fill solid front
  set object 8 circle at -limitCenterX, -limitCenterY size pointSize fc rgb 'black' fill solid front
  # Draw the curve
  plot fresnelC(t), fresnelS(t) w l lc rgb 'royalblue' lw lineWidth

  set out
}
