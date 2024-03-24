#!/bin/bash

# Função para instalar o pacote DEB
install_deb() {
  echo "Deseja instalar o pacote DEB agora? (Y/n)"
  read choice
  if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
    sudo dpkg -i "$ARTIFACT_NAME"
    if [ $? -eq 0 ]; then
      echo "Instalação bem-sucedida: $ARTIFACT_NAME"
    else
      echo "Erro: Falha na instalação do pacote DEB."
      exit 1
    fi
  else
    echo "Você optou por não instalar o pacote DEB."
  fi
}

# URL do repositório do GitHub
GH_REPO_URL="https://github.com/shiftkey/desktop"

# Obter a tag mais recente a partir do comando git ls-remote
GH_VERSION=$(git ls-remote --tags "$GH_REPO_URL" | awk -F'/' '{print $3}' | grep -oP '\d+\.\d+\.\d+\-linux\d+' | tail -n 1)

# Verificar se a versão foi encontrada
if [ -z "$GH_VERSION" ]; then
  echo "Erro: Não foi possível encontrar a tag mais recente."
  exit 1
fi

# Nome do arquivo *.deb
ARTIFACT_NAME="GitHubDesktop-linux-amd64-$GH_VERSION.deb"

# URL do release no GitHub
RELEASE_URL="https://github.com/shiftkey/desktop/releases/download/release-$GH_VERSION/$ARTIFACT_NAME"

# Baixar o release desejado
echo "Baixando $ARTIFACT_NAME..."
wget "$RELEASE_URL" -O "$ARTIFACT_NAME"

# Verificar se o download foi bem-sucedido
if [ $? -ne 0 ]; then
  echo "Erro: Falha ao baixar o release."
  exit 1
fi

echo "Download concluído: $ARTIFACT_NAME"

# Chamar a função para instalar o pacote DEB
install_deb

# Remover o arquivo DEB se não for instalado
echo "Deseja manter o arquivo DEB após a instalação? (Y/n)"
read choice
if [[ "$choice" != "Y" && "$choice" != "y" ]]; then
  rm -f "$ARTIFACT_NAME"
  echo "Arquivo DEB removido."
fi
