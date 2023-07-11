#docker run -it --rm --user=root <nombre_imagen> /bin/bash
# Imagen base
FROM debian:stable-slim


USER root
# Instalación de Git
RUN apt-get update && apt-get install -y git
# Instalacion de terraform
RUN apt-get install wget && apt-get install gpg -y
RUN apt-get update && apt-get install -y gnupg software-properties-common
RUN wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
RUN gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
RUN echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
tee /etc/apt/sources.list.d/hashicorp.list
RUN apt update
RUN apt-get install terraform
RUN terraform -help
#terraform ends

# Directorio de trabajo
WORKDIR /app
# Crear un nuevo usuario sin privilegios
RUN groupadd -g 1000 appuser && \
    useradd -r -u 1000 -g appuser appuser

# Cambiar al usuario sin privilegios
USER appuser

# Comando de entrada predeterminado
CMD ["/bin/bash"]
