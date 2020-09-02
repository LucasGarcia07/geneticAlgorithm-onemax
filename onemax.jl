"""
Algoritmo Genético para resolver o problema do onemax
"""

"""
show_pop()

Funcionalidade: imprime toda a população

Exemplo: show_pop()
    Retorno: população
"""

show_pop() = display("text/plain", populacao)


"""
obterPontuacao(individuo::AbstractArray)

Funcionalidade: dado um vetor, essa função retorna a soma dos valores

Exemplo: obterPontuacao([1, 0, 0, 1, 1])
    Retorno: 3

"""
function obterPontuacao(individuo::AbstractArray)
    sum(individuo)
end

"""
mutacao(individuo::AbstractArray)

Funcionalidade: dado um vetor de valores booleanos retorna o vetor com um dos valores trocados

Exemplo: mutacao([1, 1, 1, 1, 1])
    Retorno: [1, 1, 0, 1, 1]

"""

function mutacao(individuo::AbstractArray)

    gene = rand(1 : length(individuo))

    if individuo[gene] == 0
        individuo[gene] = 1
    else
        individuo[gene] = 0
    end
    individuo
end

"""
cruzamento(i_pai::Int, i_mae::Int, populacao::AbstractMatrix)

Funcionalidade: dado o indice de 2 vetores de uma matriz e a matriz a função
retorna um novo vetor, onde, pega os primeiros valores do primeiro vetor e os
ultimos valores do segundo vetor. o Ponto de ruptura é dado por um número
aleatório entre 1 e o tamanho dos vetores.

Exemplo: cruzamento(1, 2, [1, 1, 1; 1, 0, 0])
    Retorno: [1, 1, 0]

"""
function cruzamento(i_pai::Int, i_mae::Int, populacao::AbstractMatrix)
    tam_genes = size(populacao)[2]
    ponto = rand(1 : tam_genes)

    filho = [i <= ponto ? filho = populacao[i_pai, i] : filho = populacao[i_mae, i] for i = 1:tam_genes]

    filho
end

"""
obterMelhor(populacao::AbstractMatrix)

Funcionalidade: usando a função obterPontuacao(), essa função retorna o indice
que possui a melhor pontuação de toda a população

Exemplo: obterMelhor([1, 1, 0; 1, 0, 0])
    Retorno: 1
"""
function obterMelhor(populacao::AbstractMatrix)
    indice_melhor = 1
    pontuacao_melhor = obterPontuacao(populacao[1, :])

    for i = 2: size(populacao)[1]
        pontuacao = obterPontuacao(populacao[i, :])

        if pontuacao > pontuacao_melhor
            indice_melhor = i
            pontuacao_melhor = pontuacao
        end
    end

    indice_melhor
end

function main(tam_genes, tam_pop, tam_torneio, geracoes, prob_mut, prob_cruz)

    populacao = rand([0, 1], tam_pop, tam_genes)

    for i = 1:geracoes
        for j = 1:tam_torneio
            i_mae = 0
            i_pai = 0

            prob = rand()

            if prob < prob_cruz

                i_pai = rand(1:tam_pop)
                i_mae = rand(1:tam_pop)

                while i_pai == i_mae

                    i_mae = rand(1:tam_pop)

                end

                filho = cruzamento(i_pai, i_mae, populacao)

                if prob < prob_mut
                    filho = mutacao(filho)
                end

                score_pai = obterPontuacao(populacao[i_pai, :])
                score_filho = obterPontuacao(filho)

                if score_filho > score_pai
                    populacao[i_pai, :] = filho
                end
            end

        end

        println("Geracao: ", i)

        indice_melhor = obterMelhor(populacao)
        score_melhor = obterPontuacao(populacao[indice_melhor, :])

        println("Melhor: ", populacao[indice_melhor, :])
        println("Pontuacao: ", score_melhor)

        if score_melhor == tam_genes
            break
        end
    end
end

main(1000, 50, 200, 600, 0.1, 0.8)
