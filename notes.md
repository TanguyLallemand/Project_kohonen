#Notes

Protein blocks with a lenght of five residues, we get torsions angles (phi, psi) wich is dihedral angles
phi is angle between N-C
psi C-C
and omega is angle between amino acid (allowing rotation between aa, can go between 0 and 180)

In a protein block we do not consider first and last angles because they are linked to next or previous protein block. So we consider 8 angles
Because of overlap and sliding window two protein blocks following are sharing 4 amino acids. So, in a protein sequence of 15 aa, we consider protein blocks

For example, in a protein of 10 aa:
- First protein block is psi1 to phi5
- Second pb is psi2 to phi6
- Third pb is psi3, phi3, psi4, phi5, psi5, phi6, psi6, phi7,psi7


Algorithm:
- 
