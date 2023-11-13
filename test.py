import openai
openai.api_key = "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"   #将第二步获取的密钥填写到这里
completion = openai.ChatCompletion.create(
  model="gpt-3.5-turbo",
  messages=[
    {"role": "user", "content": "介绍一下广州塔"}
  ]
)
print(completion.choices)