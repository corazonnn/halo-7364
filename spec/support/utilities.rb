# ログインする
def sign_in_as(user)
  post login_path, params: { session: { email: user.email, password: user.password } }
end
def create_product(product)
  post products_path, params: { product: {language: product.language,title: product.title,  detail: product.detail, period: product.period, user: user } }
end