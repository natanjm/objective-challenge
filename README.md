# ObjectiveChallenge
Este projeto foi proposto durante o processo de contratação da empresa Objective.

Para iniciar seu servidor Phoenix:

  * Inicie o contêiner docker: `docker-compose up -d`
  * Execute `mix setup` para instalar e configurar dependências
  * Inicie o endpoint Phoenix com `mix phx.server` ou dentro do IEx com `iex -S mix phx.server`

        docker-compose up -d
        mix setup
        mix phx.server


Há uma coleção Postman para testar a API