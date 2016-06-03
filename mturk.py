import boto.mturk.connection

sandbox_host = 'mechanicalturk.sandbox.amazonaws.com'
real_host = 'mechanicalturk.amazonaws.com'

mturk = boto.mturk.connection.MTurkConnection(
    aws_access_key_id = 'AKIAILDKNF42ZKLRUR4Q',
    aws_secret_access_key = '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',
    host = sandbox_host,
    debug = 1 # debug = 2 prints out all requests.
)
mturk._connection
print boto.Version # 2.29.1
print mturk.get_account_balance() # [$10,000.00]

url = "https://tranquil-earth-60828.herokuapp.com/graph/waiting_room/"
title = "Demo one vs one routing game walid demo 3"
description = "The more verbose description of the job!"
keywords = ["traffic", "game", "UCB"]
frame_height = 800 # the height of the iframe holding the external hit
amount = .05

questionform = boto.mturk.question.ExternalQuestion( url, frame_height )

create_hit_result = mturk.create_hit(
    title = title,
    description = description,
    keywords = keywords,
    question = questionform,
    max_assignments=1,
    reward = boto.mturk.price.Price( amount = amount),
    response_groups = ( 'Minimal', 'HITDetail' ), # I don't know what response groups are
)

HIT = create_hit_result[0]
assert create_hit_result.status

print '[create_hit( %s, $%s ): %s]' % ( url, amount, HIT.HITId )