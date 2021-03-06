#
# Copyright 2018-2019 IBM Corp. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM codait/max-base:v1.3.2

# Fill in these with a link to the bucket containing the model and the model file name
ARG model_bucket=https://max-cdn.cdn.appdomain.cloud/max-audio-sample-generator/1.0.0
ARG model_files=assets.tar.gz

WORKDIR /workspace

# Get model archive and unzip it to assets folder
RUN wget -nv ${model_bucket}/${model_files} --output-document=assets/${model_files} --show-progress --progress=bar:force:noscroll && \
  tar -x -C assets/ -f assets/${model_files} -v && rm assets/${model_files}

COPY requirements.txt /workspace
RUN pip install -r requirements.txt

COPY . /workspace

# check file integrity
RUN sha512sum -c sha512sums.txt

EXPOSE 5000

CMD python app.py
