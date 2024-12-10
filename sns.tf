resource "aws_sns_topic" "tekuchi_sns_topic" {
  name = "tekuchi-sns-topic"
}

resource "aws_sns_topic_subscription" "email_target" {
  topic_arn = aws_sns_topic.tekuchi_sns_topic.arn
  protocol  = "email"
  ### insira seu e-mail abaixo
  endpoint  = "email@example.com"
}