reset
set angle rad

#=================== Parameters ====================
N = int(5e3)       # If you integrate using Simpson's rule, N is even.
lineWidth = 1.5
trange = 15.       #[-trange:trange]

limitCenterX = sqrt(pi)/2
limitCenterY = sqrt(pi)/2

#=================== Functions ====================
# Integrands of Fresnel integrals
c(t) = cos(t**2)
s(t) = sin(t**2)

# Fresnel integral using composite Simpson's rule
fresnelC(t) = (h = t/N, h/3*(sum[i=1:N/2]c((2*i-2)*h)+4*c((2*i-1)*h)+c(2*i*h)))
fresnelS(t) = (h = t/N, h/3*(sum[i=1:N/2]s((2*i-2)*h)+4*s((2*i-1)*h)+s(2*i*h)))

#=================== Setting ====================
set term pngcairo truecolor enhanced dashed size 640, 480 font 'Times, 16'
set key right bottom spacing 1.3 # default=1
set grid
set samples 5e3
set xrange [-5:5]
set yrange [-1:1]
set xlabel '{/:Italic t}'
set ylabel '{/:Italic C}({/:Italic t}) ,  {/:Italic S}({/:Italic t})'
set tics font ', 14'

#=================== Plot ====================
set output "fresnelCS.png"
plot fresnelC(x) w l lc rgb '0x0086C8' lw lineWidth t '{/:Italic C}({/:Italic t})', \
     fresnelS(x) w l lc rgb '0xFF5050' lw lineWidth t '{/:Italic S}({/:Italic t})'
set out
