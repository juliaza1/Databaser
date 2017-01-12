select p.navn, p.personnr, b.adr, b.bolignr
from Person p, Boligsalg b, Salgspart s
where s.salgsrolle = 'megler' and s.salgsrolle = 'kjøper' and s.salgsrolle = 'selger'
	and p.personnr = s.personnr and s.salgsnr = b.salgsnr


