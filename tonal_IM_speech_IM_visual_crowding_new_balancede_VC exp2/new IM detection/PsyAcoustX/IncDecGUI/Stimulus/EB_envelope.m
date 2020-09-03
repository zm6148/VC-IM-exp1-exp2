function y=EB_envelope(x)
a=hilbert(x);
b=real(a).*real(a);
c=imag(a).*imag(a);
y=sqrt(b+c);