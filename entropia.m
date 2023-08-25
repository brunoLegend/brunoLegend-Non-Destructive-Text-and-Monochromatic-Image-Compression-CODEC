function soma = entropia(fonte)

%CONTAGENS
f=fonte(:);
alfabeto=unique(f);
contagens = zeros(size(alfabeto));

for k=1:length(f) %itera a fonte

    for i=1:length(alfabeto) %itera o alfabeto
        if(alfabeto(i) == fonte(k))
            contagens(i) = contagens(i)+1;
        end
    end
    
end

%ENTROPIA
c=contagens(:); %vetor de contagens calculadas
nelementos=sum(c);
probabilidades=zeros(size(c)); %vetor para as probabilidades a calcular

soma=0;
for i=1:length(c)
    probabilidades(i)=contagens(i)/nelementos;
    
    if probabilidades(i) ~= 0
        soma = soma + probabilidades(i) * log2(1/probabilidades(i));
    end
    
end

end