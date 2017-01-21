function B = gmrf_B(m, n, t1, t2, t3, t4)
	B = zeros(m,n);
	B(1,1)=1;
	B(1,2)=-t1;
	B(1,end)=-t1;
	B(2,1)=-t2;
	B(2,2)=-t3;
	B(2,end)=-t4;
	B(end,1)=-t2;
	B(end,2)=-t4;
	B(end,end)=-t3;
	
