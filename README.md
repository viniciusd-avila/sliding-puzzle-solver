# Sliding Puzzle Solver

Common Lisp implementation of the [A\* search algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) to solve n-by-n sliding puzzles.

![8-puzzle example](https://github.com/viniciusd-avila/sliding-puzzle-solver/blob/master/8-puzzle-example.png)

Call `(solve '(0 1 3 4 2 5 7 8 6) #'manhattan-dist)` to get a list of moves to solve the puzzle. Manhattan-dist is a heuristic function, you can alternatevely use the less eficient *hamming-dist* passing it as the 2nd argument of the *solve* function.  

## Relatório para a disciplina Estrutura de Dados e Algoritmos (2017/01)

O projeto foi realizado em dupla, com o aluno Matheus Assis, solucionando o Sliding Puzzle, isto é, dado um tabuleiro n x n com (n² – 1) peças numeradas de 1 a (n² – 1) em ordem qualquer, e sejam movimentos legítimos apenas aqueles que “arrastam” uma peça vizinha para a casa vazia do tabuleiro, retornamos todos os movimentos necessários para que essas peças sejam dispostas em ordem numérica. 

A escolha do tema se deu principalmente por um interesse maior que compartilhamos por desafios envolvendo jogos de tabuleiro (notavelmente, o xadrez). Os materiais utilizados foram o [8-puzzle assignment](http://www.cs.princeton.edu/courses/archive/spring18/cos226/assignments/8puzzle/index.html) do curso _Algorithms and Data Structures_ da Universidade de Princeton, o artigo da Wikipédia inglesa sobre o algoritmo [A* search](https://en.wikipedia.org/wiki/A*_search_algorithm), a biblioteca [CL-HEAP](https://common-lisp.net/project/cl-heap/), além do livro Practical Common Lisp. Estimo que o tempo total gasto puramente programando, debugando e pensando na solução concentra, ou seja, não contabilizando as horas para redigir este relatório, tenha sido no total aproximadamente 20 horas para cada aluno da dupla. 

A solução do desafio envolve a implementação do algoritmo _A* search_. Para compreendê-lo podemos começar pensando em qual seria a solução ingênua do problema: gerar uma árvore de tabuleiros de forma que para cada movimento um novo tabuleiro seja acrescentado até que eventualmente o tabuleiro cujo estado é o desejado (ou seja, todas as peças são dispostas em ordem numérica) seja atingido. Devido ao fator de ramificação, isso seria muito pouco viável, tanto em virtude do tempo quanto da memória gasta.  

Ao usar o _A* search_, o que faremos é, também, gerar uma árvore e um conjunto de tabuleiros a partir do inicial (que serão no mínimo 2 e no máximo 4), porém associar um peso a cada tabuleiro gerado, e com esse peso associado inserir os tabuleiros em uma fila de prioridade. Depois disso, fazemos o _dequeue_, o que nos retornará o tabuleiro de menor peso, e assim inseriremos na fila de prioridade os filhos apenas desse tabuleiro. Durante todo o processo, que se repete até atingirmos o estado desejado, apenas os filhos dos tabuleiros que tem o menor peso dentro da fila de prioridade são efetivamente criados, o que é bem mais econômico do que a solução de busca exaustiva em largura (que denominamos de ingênua). 

A complexidade do algoritmo é dada em função do fator de ramificação r e da profundidade p da solução, isto é, do número de movimentos necessários para alcançar o estado final, na forma O(_r_ <sup>p</sup>). Não é trivial estimar o fator de ramificação devido às diversas heurísticas e optimizações possíveis para cada implementação; no pior dos casos, para o nosso problema do _Sliding Puzzle_, sem contar as optimizações nosso _r_ seria aproximadamente igual a 3 (média dos números máximo e mínimo de filhos por tabuleiro), e _p_ depende do tamanho do tabuleiro. 

Para representar o tabuleiro, criamos uma classe chamada _board_, cujo atributo principal é _state_, onde armazenamos um _array_ de tamanho _n_ ² que indica as peças e suas posições, e onde o número 0 representa uma casa vazia. _Father_ é um atributo que recebe um outro objeto da classe _board_, de onde aquela instância originou-se, útil para quando chegarmos ao estágio final do algoritmo e quisermos saber quais foram os movimentos necessários para chegar até lá. _Distance_ e _movecount_ estão relacionados à determinação de um peso ao inserir o tabuleiro na fila de prioridade, movecount simplesmente guarda o número de movimentos feitos para chegar até aquele estado. Piece guarda qual peça foi movida em relação ao tabuleiro-pai para chegar a tal estado, e finalmente zeropos indica a posição da casa vazia no tabuleiro. 

Existem duas funções de possível uso para auxiliar no cálculo do peso. A mais simples é a _hamming-dist_, que simplesmente soma o número de peças na posição errada. Já a _manhattan-dist_ soma as distâncias verticais e horizontais de cada peça em relação à posição correta no tabuleiro. O primeiro método não leva em consideração o quão longe uma peça está de sua posição ideal, por isso é bem menos eficiente. O valor da prioridade a ser usado é justamente a soma dos atributos movecount e distance, sendo que a última pode ser resultado da _hamming-dist_ ou _manhattan-dist_, a ser passada como argumento da função principal solve. 

Ao chamarmos a função solve com um estado inicial, antes de tudo decidimos, em is-solvable, se tal estado é sequer passível de solução. Para isso precisamos considerar o número de inversões presentes no tabuleiro, isto é, o número de peças i e j tais que i < j mas a peça i aparece depois do j na representação linear do tabuleiro (justamente aquela utilizada no atributo state, com um array de tamanho n²). A complexidade temporal da contagem do número de inversões é O(_n_ <sup>4</sup>), porém só é computada uma vez no início do programa e satisfaz as exigências do assignment. 

Tendo armazenado o número de inversões em um tabuleiro, temos que separar a solubilidade do problema em dois casos, quando o tabuleiro tem dimensões ímpares ou pares. Quando é ímpar, então cada movimento muda o número de inversões por um número par, e já que queremos que o número de inversões seja 0, então necessariamente, para que o tabuleiro seja resolvível, então já desde o início deve haver um número par de inversões. Já se o tabuleiro tem dimensão par, então temos que considerar também a linha em que a casa vazia está presente e adicionar ao número de inversões, verificar se é par para então decidir a solubilidade. 

Uma vez concluído que o tabuleiro é resolvível, geramos seus filhos em _gen-children_, calculamos seu peso/prioridade e enfileiramos cada um deles na _game-tree_. Fazemos o dequeue, que nos dá o tabuleiro com menor peso, verificamos se esse é justamente o tabuleiro cujas posições são as corretas, e novamente enfileiramos os filhos do tabuleiro que foi retirado, exatamente como na descrição do _A* search_ previamente. Porém com uma optimização, checamos em _is-grandparent_ se o estado do filho não é o mesmo que o do pai de seu pai, se for o caso, sequer enfileiramos o objeto, de modo a evitar desperdício de tempo, memória, e talvez até problemas com loops infinitos.  

Uma vez alcançado o estado final, chamamos a função _unroll_, que recursivamente percorre os atributos _father_ e _piece_ dos tabuleiros até chegar no início da _game-tree_, o que nos dá cada movimento realizado para solucionar o puzzle. 

#### Como testar? 

Uma vez que tenha-se baixado e compilado a biblioteca CL-HEAP, preferencialmente com o uso do quicklisp, para testar é necessário representar o tabuleiro linearmente como uma lista, de modo que o quadro no topo desta página seja escrito na forma ‘(0 1 3 4 2 5 7 8 6). 
 
Também é necessário escolher entre _hamming-dist_ ou _manhattan-dist_. Feito isso, basta salvar, compilar e carregar o arquivo sliding-puzzle.lisp, e chamar a função solve da forma: 

CL-USER 10 : 1 > (solve '(0 1 3 4 2 5 7 8 6) #'manhattan-dist) 
#(1 0 3 4 2 5 7 8 6)  
#(1 2 3 4 0 5 7 8 6)  
#(1 2 3 4 5 0 7 8 6)  
#(1 2 3 4 5 6 7 8 0)  
Número de movimentos: 4 
Ordem de peças a serem movidas: (1 2 5 6) 
 
Uma lista de testes com tabuleiros de diferentes dimensões foi fornecida no repositório 
