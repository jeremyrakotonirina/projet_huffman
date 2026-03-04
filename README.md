# Projet Huffman

## Membres

- Jeremy Rakotonirina

## Description

Ce projet implémente **l’algorithme de compression de Huffman** en OCaml.  
Il permet :

- **Compression** d’un fichier texte en un fichier binaire au format personnalisé (`.hf`)
- **Décompression** d’un fichier `.hf` vers un fichier texte
- **Affichage de statistiques** sur la compression (taille avant / après, taux de compression)
- Manipulation de **flux binaires** (lecture/écriture bit à bit)
- Construction et utilisation d’un **arbre de Huffman** via un **tas binaire** (min-heap)

## Structure du projet

- `huff.ml` : point d’entrée du programme (fonction `main`), gestion des options de la ligne de commande.
- `huffman.ml` : implémentation de l’algorithme de Huffman :
  - calcul des fréquences des caractères
  - construction de l’arbre de Huffman
  - génération des codes binaires
  - compression / décompression
- `heap.ml` / `heap.mli` : implémentation d’un **tas binaire min** pour gérer les nœuds de l’arbre pendant la construction.
- `bs.ml` / `bs.mli` : module de **bitstream** (lecture / écriture bit à bit dans des canaux OCaml).
- `dune`, `dune-project`, `dune-workspace` : fichiers de configuration du projet Dune.
- `test1.txt`, `test2.txt` : fichiers texte d’exemple pour tester la compression / décompression.

## Compilation

Le projet utilise **Dune** comme système de build.

### Prérequis

- OCaml installé (par exemple via `opam`)
- Dune installé (`opam install dune` si besoin)

### Construction du projet

Depuis le dossier racine du projet (`projet_huffman-main`):
`dune build`

Si tout se passe bien, l’exécutable sera construit dans _build/default/

# **Utilisation**


Le programme se lance en ligne de commande avec différentes options.


---


## **Aide**


`huff.exe --help`


Affiche :
• La liste des **options**.
• Le **rôle** de chaque option.
• Le comportement sur les fichiers **.hf** ou non **.hf**.


---


## **Compression d’un fichier texte**


`huff.exe mon_fichier.txt`


• Vérifie que `mon_fichier.txt` **existe**.
• Produit un fichier compressé `mon_fichier.txt.hf`.
• Affiche un message du type :
`Compression du fichier mon_fichier.txt dans mon_fichier.txt.hf`


---


## **Décompression d’un fichier .hf**


`huff.exe mon_fichier.txt.hf`


• Vérifie que `mon_fichier.txt.hf` **existe**.
• Produit un fichier décompressé nommé `2mon_fichier.txt` (le préfixe **2** est ajouté pour le distinguer du fichier original).
• Affiche un message du type :
`Décompression du fichier mon_fichier.txt.hf dans 2mon_fichier.txt`


---


## **Statistiques de compression**


`huff.exe --stats mon_fichier.txt`





Le programme compresse le fichier et calcule :
• La **taille originale** (en octets).
• La **taille compressée** (en octets).
• Le **taux de compression** en pourcentage.


**Exemple d'affichage :**
 Statistiques de compression :
Taille originale : 1234 octets
Taille compressée : 456 octets
Taux de compression : 63.06%

---


## **Codes d’erreur**


Le programme retourne différents codes d’erreur (via `exit`) :


• **1** : Option non reconnue.
• **2** : Erreur sur le nombre d’arguments (trop ou pas assez).
• **3** : Fichier inexistant.

# **Tests**


Deux fichiers d’exemple sont fournis :
• **test1.txt**
• **test2.txt**





---


## **Exemple de scénario de test**


### **1. Compression**


`huff.exe test1.txt`


---


### **2. Décompression**


`huff.exe test1.txt.hf`


---


### **3. Comparaison**


Vérifier que **test1.txt** et **2test1.txt** ont le même contenu (visuellement ou avec un outil de diff).


---


### **4. Statistiques**


`huff.exe --stats test1.txt`
