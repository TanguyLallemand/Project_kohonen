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




PB-torsion file generation

Algorithm:
- Each cells have a value. For each value that we want to classify,


Summary:
- Obtaining datas from PISCES
- DSSP to obtain psi and phi angles
- Generate PB dataset composed by 16 protein blocks
    - a, b, -> c alpha-N-cap
    - d -> beta
    - e, f -> c-cap-beta
    - g, h -> coil
    - m -> alpha
    - n,o,p -> c-cap-alpha


For protein block a we have a training dataset.

Algorithm:
random vector file (-180,180), Generate initial map. Using training dataset, Calculate RMSD and put it in right cell
