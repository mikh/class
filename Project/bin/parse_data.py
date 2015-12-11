
def parse_some_data(in_file, out_file):
	with open(in_file, 'r') as f:
		with open(out_file, 'w') as of:	
			ll = f.readlines()
			line = ''
			for ii in range(0, len(ll)):
				if '=' in ll[ii]:
					line += ' ' + ll[ii].split('=')[1].strip()
				elif 'correct' in ll[ii]:
					line += ' ' + ll[ii].split('correct')[0].strip()
				else:
					of.write(line + '\n')
					line = ''

parse_some_data('learning_by_example_data.txt', 'example_parse.txt')
parse_some_data('learning_by_epoch_data', 'epoch_parse.txt')

