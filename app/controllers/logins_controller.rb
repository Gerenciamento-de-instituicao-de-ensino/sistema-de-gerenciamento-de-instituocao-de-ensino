class LoginsController < ApplicationController

  def index
    @email = ""
    @senha = ""
    @resultadoLogin = ""
    Pessoa.verificar_cadastro_gerente
  end

  def sair
    Pessoa.set_pessoa_logada(nil)
    redirect_to logins_path
  end

  def create
    email = params[:email]
    senha = params[:senha]
    if validarDados(email, senha)
      pessoa = Pessoa.login(email, senha)
      if pessoa.nil?
        @email = email
        @senha = senha
        @resultadoLogin = "erro-Login Iválido"
        render "logins/index"
      else
        Pessoa.set_pessoa_logada(pessoa)
        if pessoa.tipo == 1
          # abre funcionario
          redirect_to funcionarios_perfil_path
        else
          redirect_to clientes_perfil_url
        end
      end
    else
      @email = email
      @senha = senha
      render 'logins/index'
    end
  end

  private

  def validarDados email, senha
    resultado = true
    if verificarCampoVazioOuNulo email
      @resultadoLogin = "erro-Preencha o campo de email ou cpf"
      resultado = false
    elsif verificarCampoVazioOuNulo senha
      @resultadoLogin = "erro-Preencha o campo de senha"
      resultado = false
    end
    resultado
  end

  def verificarCampoVazioOuNulo string
    resultado = false
    if string.nil? || string == ''
      resultado = true
    end
    resultado
  end

end