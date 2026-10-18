# Rauny IPTV Player — gerar IPA pelo GitHub

Projeto de teste para iPhone/iPad, baseado na v1.4.7. A compilação nativa ainda precisa ser executada e validada no GitHub. Este pacote não contém um IPA pronto.

## Criar o repositório

1. Entre em https://github.com/new com a conta lucienessf-star.
2. Use o nome rauny-iptv-ios.
3. Para usar os servidores padrão gratuitos sem quota de repositório privado, escolha Public **somente se concordar em tornar o código do app público**. Os arquivos deste pacote não incluem sua lista, credenciais IPTV, conta Apple, certificados ou perfis do navegador.
4. Ative Add a README file e clique Create repository.
5. No repositório, escolha Add file > Upload files.
6. Extraia o ZIP recebido no PC. Abra a pasta extraída e arraste o CONTEÚDO dela: a pasta .github, projeto-ios.zip e README.md. Não arraste a pasta externa que contém esses três itens.
7. Confirme a gravação em Commit changes. Na página principal deve existir a pasta .github e o arquivo projeto-ios.zip diretamente na raiz.

## Rodar o Mac na nuvem

1. Abra Actions > Gerar IPA do Rauny para AltStore.
2. Clique Run workflow, escolha main e confirme Run workflow.
3. Aguarde a execução. Não existe garantia de sucesso antes dessa primeira compilação nativa.
4. Se ficar vermelho, abra a etapa com erro e envie o primeiro erro relevante na conversa.
5. Se ficar verde, abra a execução e, em Artifacts, baixe Rauny-IPTV-iPad-IPA.
6. Extraia esse download: dentro dele estará Rauny-IPTV-iPad-1.4.7.ipa.

## Instalar

O IPA gerado não contém assinatura Apple de distribuição. O AltStore/AltServer fará a assinatura com sua conta e instalará no aparelho. Mantenha o AltServer aberto no Windows. Transfira o IPA para Arquivos no iPad; no AltStore, abra My Apps > + e selecione o IPA. Com conta gratuita, a assinatura exige renovação periódica (normalmente 7 dias). A renovação não exige recompilar a mesma versão.

## O que o fluxo faz

- Roda manualmente em macos-26 padrão, com limite de 45 minutos por execução.
- Obtém o Flutter 3.47.7 do repositório oficial, prepara dependências e executa os testes.
- Compila para aparelho iPhone/iPad com --no-codesign, confere arm64 e monta Payload/Runner.app dentro do IPA.
- Publica o arquivo apenas como artefato da execução, por 3 dias. Não publica na App Store e não cria uma Release.
- Não solicita senha Apple, certificado nem segredo de assinatura no GitHub.
- Repositório privado tem regras de minutos/cobrança diferentes. Este roteiro não configura pagamentos nem servidores maiores.

## Testes e limitações

Os testes Flutter locais cobrem login, layouts, controles, rotação, mute e o envio de downloads simulados. O player nativo para iOS solicita ocultar as barras do sistema ao expandir e restaurá-las ao voltar. Compilar e testar fisicamente continuam pendentes.
O download iOS precisa manter o app aberto; arquivos diretos ficam em Arquivos > No meu iPad/iPhone > Rauny IPTV Player > Downloads. HLS/DASH não são convertidos.
A versão Android aprovada e o player web continuam separados.

Fontes: https://docs.github.com/en/actions/reference/runners/github-hosted-runners e https://docs.flutter.dev/deployment/ios
